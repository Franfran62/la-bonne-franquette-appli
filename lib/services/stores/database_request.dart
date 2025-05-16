import 'package:la_bonne_franquette_front/models/category.dart';
import 'package:la_bonne_franquette_front/models/enums/tables.dart';
import 'package:la_bonne_franquette_front/models/addon.dart';
import 'package:la_bonne_franquette_front/models/ingredient.dart';
import 'package:la_bonne_franquette_front/models/menuItem.dart';
import 'package:la_bonne_franquette_front/models/payment_type.dart';
import 'package:la_bonne_franquette_front/models/product.dart';
import 'package:la_bonne_franquette_front/services/stores/database_setup.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/menu.dart';

class DatabaseRequest {
  static Database? database;
  static String databaseVersion = "0";

  static Future<void> initDatabase() async {
    String path = join(await getDatabasesPath(), 'carte_database.db');
    await deleteDatabase(path);

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        DatabaseSetup.create(db);
      },
    );
  }

  static Future<void> insert(Tables table, Map<String, dynamic> data) async {
    final columns = await getTableColumns(table.name);
    final filteredData = Map<String, dynamic>.from(data)
      ..removeWhere((key, value) => !columns.contains(key));
    await database?.insert(
      table.name,
      filteredData,
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
  }

  static Future<List<String>> getTableColumns(String tableName) async {
    final result = await database?.rawQuery('PRAGMA table_info($tableName)');
    return result?.map((row) => row['name'] as String).toList() ?? [];
  }

  static Future<List<Menu>> findAllMenus() async {
    List<Menu> menus = [];
    final result = await database?.query('menus');

    for (var menuMap in result ?? []) {
      List<MenuItem> menuItems = [];
      final menuItemsResult = await database?.query(
        'menu_items',
        where: 'menu_id = ?',
        whereArgs: [menuMap['id']],
      );
      for (var itemMap in menuItemsResult ?? []) {
        final productResult = await database?.query(
          'menu_item_contains_product',
          where: 'menu_item_id = ?',
          whereArgs: [itemMap['id']],
        );
        List<Product> products = [];
        for (var el in (productResult ?? [])) {
          final product =
              await DatabaseRequest.findProductById(el['product_id'] as int);
          if (product != null) {
            products.add(product);
          } else {
            print("Produit introuvable pour product_id=${el['product_id']}");
          }
        }
        menuItems.add(MenuItem(
          id: itemMap['id'],
          optional: itemMap['optional'] == 1,
          totalPrice: itemMap['totalPrice'],
          products: products,
        ));
      }

      menus.add(Menu(
        id: menuMap['id'],
        name: menuMap['name'],
        totalPrice: menuMap['totalPrice'] ?? menuMap['totalPrice'],
        menuItems: menuItems,
      ));
    }
    return menus;
  }

  static Future<List<Category>> findAllCategories() async {
    List<Category> categories = [];
    final result = await database?.query(Tables.category.name,
        columns: ["id"], orderBy: "categoryType");
    List<int> categorieIDs =
        result?.map((e) => e.values.first as int).toList() ?? [];
    for (int e in categorieIDs) {
      List<Product> products = await findAllProductByCategoryId(e);
      final categorieResult =
          await database?.query(Tables.category.name, where: "id = $e");

      Map<String, Object?> map =
          Map<String, Object?>.from(categorieResult?.first ?? {});

      map["products"] = products;

      if (map['categoryType'] == "sub-category") {
        categories
            .firstWhere((c) => c.id == map["categoryId"])
            .subCategories
            .add(Category.fromMap(map));
      } else {
        categories.add(Category.fromMap(map));
      }
    }
    return categories;
  }

  static Future<Product?> findProductById(int id) async {
    final result = await DatabaseRequest.database?.query(
      Tables.product.name,
      where: "id = ?",
      whereArgs: [id],
    );

    if (result != null && result.isNotEmpty) {
      return Product.fromMap(result.first);
    }
    return null;
  }

  static Future<List<Product>> findAllProductByCategoryId(int categoryId) async {
    final result = await database?.query(Tables.productInCategory.name,
        where: "category_id = $categoryId", columns: ["product_id"]);
    List<int> productIDs =
        result?.map((e) => e.values.first as int).toList() ?? [];
    return findAllProductById(productIDs);
  }

  static Future<List<Product>> findAllProductById(List<int> productIDs) async {
    List<Product> products = [];
    for (int e in productIDs) {
      final productResult =
          await database?.query(Tables.product.name, where: "id = $e");
      Map<String, Object?> map =
          Map<String, Object?>.from(productResult?.first ?? {});
      products.add(Product.fromMap(map));
    }
    return products;
  }

  static Future<List<Ingredient>> findAllIngredientByProductId(
      int productId) async {
    final result = await database?.rawQuery('''
      SELECT ingredients.*
      FROM ingredients
      INNER JOIN product_contains_ingredient
      ON ingredients.id = product_contains_ingredient.ingredient_id
      WHERE product_contains_ingredient.product_id = ?
    ''', [productId]);

    return result?.map((e) => Ingredient.fromMap(e)).toList() ?? [];
  }

  static Future<List<Addon>> findAllAddonByProductId(int productId) async {
    final result = await database?.rawQuery('''
      SELECT addons.*
      FROM addons
      INNER JOIN product_contains_addon
      ON addons.id = product_contains_addon.addon_id
      WHERE product_contains_addon.product_id = ?
    ''', [productId]);

    return result?.map((e) => Addon.fromMap(e)).toList() ?? [];
  }

  static Future<List<PaymentType>> findAllPaymentTypeEnable() async {
    final result = await database?.query('payment_type', where: 'isEnable = 1');
    return result?.map((e) => PaymentType.fromMap(e)).toList() ?? [];
  }
}
