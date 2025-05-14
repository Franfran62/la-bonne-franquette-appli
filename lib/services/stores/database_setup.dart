import 'dart:core';

import 'package:la_bonne_franquette_front/models/category.dart';
import 'package:la_bonne_franquette_front/models/enums/tables.dart';
import 'package:la_bonne_franquette_front/models/addon.dart';
import 'package:la_bonne_franquette_front/models/ingredient.dart';
import 'package:la_bonne_franquette_front/models/interface/identifiable.dart';
import 'package:la_bonne_franquette_front/models/menu.dart';
import 'package:la_bonne_franquette_front/models/payment_type.dart';
import 'package:la_bonne_franquette_front/models/product.dart';
import 'package:la_bonne_franquette_front/services/api/api_request.dart';
import 'package:la_bonne_franquette_front/services/stores/database_request.dart';

class DatabaseSetup {

  static void create(dynamic db) {
    db.execute('''
      CREATE TABLE ingredients (
        id INTEGER PRIMARY KEY,
        name VARCHAR(50) NOT NULL
      );
    ''');
    db.execute('''
      CREATE TABLE addons (
        id INTEGER PRIMARY KEY,
        name VARCHAR(50) NOT NULL,
        totalPrice INTEGER(11) NOT NULL
      );
    ''');
    db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY,
        name varchar(50) NOT NULL,
        categoryType varchar(20) NOT NULL,
        categoryId INTEGER DEFAULT NULL
      );
    ''');
    db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY,
        name varchar(50) NOT NULL,
        totalPrice INTEGER(11) NOT NULL
      );
    ''');
    db.execute('''
      CREATE TABLE menus (
        id INTEGER PRIMARY KEY,
        name varchar(50) NOT NULL,
        totalPrice INTEGER(11) NOT NULL
      );
    ''');
    db.execute('''
      CREATE TABLE menu_items (
        id INTEGER PRIMARY KEY,
        optional INTEGER NOT NULL,
        totalPrice INTEGER,
        menu_id INTEGER NOT NULL,
        FOREIGN KEY (menu_id) REFERENCES menu(id)
      );
    ''');
    db.execute('''
      CREATE TABLE menu_item_contains_product (
        menu_item_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        FOREIGN KEY (menu_item_id) REFERENCES menu_item(id),
        FOREIGN KEY (product_id) REFERENCES product(id)
      );
    ''');
    db.execute('''
      CREATE TABLE product_contains_ingredient (
        product_id INTEGER,
        ingredient_id INTEGER,
        FOREIGN KEY (product_id) REFERENCES product(id),
        FOREIGN KEY (ingredient_id) REFERENCES ingredient(id)
      );
    ''');
    db.execute('''
      CREATE TABLE product_contains_addon (
        product_id INTEGER,
        addon_id INTEGER,
        FOREIGN KEY (product_id) REFERENCES product(id),
        FOREIGN KEY (addon_id) REFERENCES addon(id)
      );
    ''');
    db.execute('''
      CREATE TABLE product_in_category (
        product_id INTEGER,
        category_id INTEGER,
        FOREIGN KEY (product_id) REFERENCES product(id),
        FOREIGN KEY (category_id) REFERENCES categorie(id)
      );
    ''');
    db.execute('''
      CREATE TABLE payment_type (
        id INTEGER PRIMARY KEY,
        name VARCHAR(50) NOT NULL,
        isEnable INTEGER NOT NULL
      );
    ''');
  }

  static Future<void> initStores() async {
    await DatabaseRequest.initDatabase();
    await initStore<Ingredient>('ingredient');
    await initStore<Addon>('addon');
    await initStore<Category>('category');
    await initStore<Product>('product');
    await initStore<Menu>('menu');
    await initStore<PaymentType>('payment/type');
    return;
  }

  static Future<void> initStore<T>(String endpoint) async {
    try {
      final response =
          await ApiRequest.fetchAll(endpoint: "/$endpoint", token: true);
      switch (endpoint) {
        case "ingredient":
          for (var i in response) {
            print(i);
            await DatabaseRequest.insert(
                Tables.ingredient, i as Map<String, dynamic>);
          }
          break;
        case "addon":
          for (var i in response) {
            print(i);
            await DatabaseRequest.insert(
                Tables.addon, i as Map<String, dynamic>);
          }
          break;
        case "category":
          for (var i in response) {
            print(i);
            await DatabaseRequest.insert(
                Tables.category, i as Map<String, dynamic>);
          }
          break;
        case "payment/type":
          for (var i in response) {
            print(i);
            await DatabaseRequest.insert(
                Tables.paymentType, i as Map<String, dynamic>);
          }
          break;
        case "product":
          for (var i in response) {
            print(i);
            Product product = Product.fromJson(i);
            List<Category> categories = product.getCategories();
            List<Ingredient> ingredients = product.getIngredients();
            List<Addon> extras = product.getAddons();

            await DatabaseRequest.insert(Tables.product, product.register());
            await link<Category>(Tables.productInCategory, i['id'], categories);
            await link<Ingredient>(
                Tables.productContainsIngredient, i['id'], ingredients);
            await link<Addon>(Tables.productContainsAddon, i['id'], extras);
          }
          break;
        case "menu":
          for (var i in response) {
            print("------- MENU $i");
            Menu menu = await Menu.fromJson(i);
            await DatabaseRequest.insert(Tables.menu, {
              "id": menu.id,
              "name": menu.name,
              "totalPrice": menu.totalPrice,
            });
            for (var menuItem in menu.menuItems) {
              await DatabaseRequest.insert(Tables.menuItem, {
                "id": menuItem.id,
                "optional": menuItem.optional ? 1 : 0,
                "totalPrice": menuItem.totalPrice,
                "menu_id": menu.id,
              });
              for (var product in menuItem.products) {
                await DatabaseRequest.insert(Tables.menuItemContainsProduct, {
                  "menu_item_id": menuItem.id,
                  "product_id": product.id,
                });
              }
            }
          }
          break;

        default:
          throw Exception(
              'Impossible d\'initialiser le store pour le modèle $T');
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  static Future<void> link<T extends Identifiable>(
      Tables table, int id, List<T> items) async {
    try {
      List<String> tableSplitted = table.name.split("_");
      String referenceName = "${tableSplitted.first}_id";
      String itemName = "${tableSplitted.last}_id";

      for (T item in items) {
        await DatabaseRequest.insert(
            table, {referenceName: id, itemName: item.id});
      }
    } catch (e) {
      throw Exception("Impossible de lier les éléments dans la table $table");
    }
  }
}
