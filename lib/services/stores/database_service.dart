import 'package:la_bonne_franquette_front/models/categorie.dart';
import 'package:la_bonne_franquette_front/models/enums/tables.dart';
import 'package:la_bonne_franquette_front/models/extra.dart';
import 'package:la_bonne_franquette_front/models/ingredient.dart';
import 'package:la_bonne_franquette_front/models/menuItem.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../models/menu.dart';

class DatabaseService {
  static Database? database;
  static String databaseVersion = "0";

  static Future<void> initDatabase() async {
    String path = join(await getDatabasesPath(), 'carte2_database.db');
    await deleteDatabase(path);

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE ingredient (
            id INTEGER PRIMARY KEY,
            nom VARCHAR(50) NOT NULL,
            acuire INTEGER NOT NULL
            );
        ''');
        db.execute('''
          CREATE TABLE extra (
            id INTEGER PRIMARY KEY,
            nom VARCHAR(50) NOT NULL,
            acuire INTEGER NOT NULL, 
            prixht INTEGER(11) NOT NULL
            );
        ''');
        db.execute('''
          CREATE TABLE categorie (
            id INTEGER PRIMARY KEY,
            nom varchar(50) NOT NULL,
            categorieType varchar(20) NOT NULL,
            categorieId INTEGER DEFAULT NULL
        );
        ''');
        db.execute('''
          CREATE TABLE produit (
            id INTEGER PRIMARY KEY,
            nom varchar(50) NOT NULL,
            prixht INTEGER(11) NOT NULL
          );
        ''');
        db.execute('''
          CREATE TABLE menu (
            id INTEGER PRIMARY KEY,
            nom varchar(50) NOT NULL,
            prixht INTEGER(11) NOT NULL
          );
        ''');
        db.execute('''
          CREATE TABLE menu_item (
            id INTEGER PRIMARY KEY,
            optional INTEGER NOT NULL,
            extraPriceHT INTEGER,
            menu_id INTEGER NOT NULL,
            FOREIGN KEY (menu_id) REFERENCES menu(id)
          );
        ''');
        db.execute('''
          CREATE TABLE menu_item_contient_produit (
            menu_item_id INTEGER NOT NULL,
            produit_id INTEGER NOT NULL,
            FOREIGN KEY (menu_item_id) REFERENCES menu_item(id),
            FOREIGN KEY (produit_id) REFERENCES produit(id)
          );
        ''');
        db.execute('''
          CREATE TABLE produit_contient_ingredient (
            produit_id INTEGER,
            ingredient_id INTEGER,
            FOREIGN KEY (produit_id) REFERENCES produit(id),
            FOREIGN KEY (ingredient_id) REFERENCES ingredient(id)
          );
        ''');
        db.execute('''
          CREATE TABLE produit_contient_extra (
            produit_id INTEGER,
            extra_id INTEGER,
            FOREIGN KEY (produit_id) REFERENCES produit(id),
            FOREIGN KEY (extra_id) REFERENCES extra(id)
          );
        ''');
        db.execute('''
          CREATE TABLE produit_appartient_categorie (
            produit_id INTEGER,
            categorie_id INTEGER,
            FOREIGN KEY (produit_id) REFERENCES produit(id),
            FOREIGN KEY (categorie_id) REFERENCES categorie(id)
          );
        ''');
      },
    );
  }

  static String getDatabaseVersion() {
    return databaseVersion;
  }

  static void setDatabaseVersion(String version) {
    databaseVersion = version;
  }

  static Future<void> insert(Tables table, Map<String, dynamic> data) async {
    await database?.insert(
      table.name,
      data,
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
  }

  static Future<List<Menu>> findAllMenus() async {
    List<Menu> menus = [];
    final result = await database?.query('menu');

    for (var menuMap in result ?? []) {
      List<MenuItem> menuItems = [];
      final menuItemsResult = await database?.query(
        'menu_item',
        where: 'menu_id = ?',
        whereArgs: [menuMap['id']],
      );
      for (var itemMap in menuItemsResult ?? []) {
        final produitResult = await database?.query(
          'menu_item_contient_produit',
          where: 'menu_item_id = ?',
          whereArgs: [itemMap['id']],
        );
        List<Produit> produits = [];
        for (var el in (produitResult ?? [])) {
          final produit = await Produit.fromId(el['produit_id'] as int);
          if (produit != null) {
            produits.add(produit);
          } else {
            print("Produit introuvable pour produit_id=${el['produit_id']}");
          }
        }
        menuItems.add(MenuItem(
          id: itemMap['id'],
          optional: itemMap['optional'] == 1,
          extraPriceHT: itemMap['extraPriceHT'],
          produitSet: produits,
        ));
      }

      menus.add(Menu(
        id: menuMap['id'],
        nom: menuMap['nom'],
        prixHT: menuMap['prixHT'] ?? menuMap['prixht'],
        menuItemSet: menuItems,
      ));
    }
  return menus;
}


  static Future<List<Categorie>> findAllCategories() async {
    List<Categorie> categories = [];
    final result = await database?.query(Tables.categorie.name,
        columns: ["id"], orderBy: "categorieType");
    List<int> categorieIDs =
        result?.map((e) => e.values.first as int).toList() ?? [];
    for (int e in categorieIDs) {
      List<Produit> produits = await findProduitsByCategorieId(e);
      final categorieResult =
          await database?.query(Tables.categorie.name, where: "id = $e");

      Map<String, Object?> map =
          Map<String, Object?>.from(categorieResult?.first ?? {});

      map["produits"] = produits;

      if (map['categorieType'] == "sous-categorie") {
        categories
            .firstWhere((c) => c.id == map["categorieId"])
            .sousCategories
            .add(Categorie.fromMap(map));
      } else {
        categories.add(Categorie.fromMap(map));
      }
    }
    return categories;
  }

  static Future<Produit?> getProduitById(int id) async {
    final result = await DatabaseService.database?.query(
      Tables.produit.name,
      where: "id = ?",
      whereArgs: [id],
    );

    if (result != null && result.isNotEmpty) {
      return Produit.fromMap(result.first);
    }
    return null;
  }


  static Future<List<Produit>> findProduitsByCategorieId(
      int categorieId) async {
    final result = await database?.query(Tables.produitAppartientCategorie.name,
        where: "categorie_id = $categorieId", columns: ["produit_id"]);
    List<int> produitIDs =
        result?.map((e) => e.values.first as int).toList() ?? [];
    return findProduitByIds(produitIDs);
  }

  static Future<List<Produit>> findProduitByIds(List<int> produitIDs) async {
    List<Produit> produits = [];
    for (int e in produitIDs) {
      final produitResult = await database?.query(Tables.produit.name, where: "id = $e");
      Map<String, Object?> map = Map<String, Object?>.from(produitResult?.first ?? {});
      produits.add(Produit.fromMap(map));
    }
    return produits;
  }

  static Future<List<T>?> findAll<T>(
      Tables table, T Function(Map<String, dynamic>) fromMap) async {
    final List<Map<String, Object?>>? maps = await database?.query(table.name);
    return maps?.map(fromMap).toList();
  }

  static Future<List<MenuItem>> getMenuItemsByMenuId(int menuId) async {
    final result = await database?.query(
      'menu_item',
      where: 'menu_id = ?',
      whereArgs: [menuId],
    );

    if (result != null) {
      return result.map((item) => MenuItem.fromMap(item)).toList();
    }
    return [];
  }

  static Future<List<Produit>> findAllProduits() async {
    final result = await database?.query(Tables.produit.name);
    return result?.map((e) => Produit.fromMap(e)).toList() ?? [];
  }

  static Future<List<Ingredient>> findIngredientsByProduitId(int produitId) async {
    final result = await database?.rawQuery('''
      SELECT ingredient.*
      FROM ingredient
      INNER JOIN produit_contient_ingredient
      ON ingredient.id = produit_contient_ingredient.ingredient_id
      WHERE produit_contient_ingredient.produit_id = ?
    ''', [produitId]);

    return result?.map((e) => Ingredient.fromMap(e)).toList() ?? [];
  }

  static Future<List<Extra>> findExtrasByProduitId(int produitId) async {
    final result = await database?.rawQuery('''
      SELECT extra.*
      FROM extra
      INNER JOIN produit_contient_extra
      ON extra.id = produit_contient_extra.extra_id
      WHERE produit_contient_extra.produit_id = ?
    ''', [produitId]);

    return result?.map((e) => Extra.fromMap(e)).toList() ?? [];
  }
}
