import 'package:la_bonne_franquette_front/models/enums/tables.dart';
import 'package:la_bonne_franquette_front/models/extra.dart';
import 'package:la_bonne_franquette_front/models/ingredient.dart';
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
          CREATE TABLE produit_contient_ingredient (
            produit_id INTEGER,
            ingredient_id INTEGER,
            FOREIGN KEY (produit_id) REFERENCES produit(id),
            FOREIGN KEY (ingredient_id) REFERENCES ingredient(id)
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
        db.execute('''
          CREATE TABLE menu_contient_produit (
            menu_id INTEGER,
            produit_id INTEGER,
            FOREIGN KEY (menu_id) REFERENCES menu(id),
            FOREIGN KEY (produit_id) REFERENCES produit(id)
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

  static Future<List<Menu>?> findAllMenus() async {
    List<Menu> menus = [];
    final result = await database?.query(Tables.menu.name, columns: ["id"]);
    List<int> menuIDs =
        result?.map((e) => e.values.first as int).toList() ?? [];

    for (int e in menuIDs) {
      List<Produit> produits = [];
      final produitsInMenuResult =
          await database?.rawQuery("SELECT * FROM ${Tables.produit.name} p "
              "INNER JOIN ${Tables.menuContientProduit.name} mcp "
              "ON p.id = mcp.produit_id "
              "WHERE mcp.menu_id = $e ");
      produitsInMenuResult?.forEach((produit) {
        produits.add(Produit.fromMap(produit));
      });
      final menusResult =
          await database?.query(Tables.menu.name, where: "id = $e");
      Map<String, Object?> map =
          Map<String, Object?>.from(menusResult?.first ?? {});
      map["produits"] = produits;
      menus.add(Menu.fromMap(map));
    }
    return menus;
  }

  static Future<List<Produit>> findAllProduits() async {
    List<Produit> produits = [];
    final result = await database?.query(Tables.produit.name, columns: ["id"]);
    List<int> produitIDs =
        result?.map((e) => e.values.first as int).toList() ?? [];

    for (int e in produitIDs) {
      List<Ingredient> ingredients = [];
      final ingredientsInProduitsResult =
          await database?.rawQuery("SELECT * FROM ${Tables.ingredient.name} i "
              "INNER JOIN ${Tables.produitContientIngredient.name} pci "
              "ON i.id = pci.ingredient_id "
              "WHERE pci.produit_id = $e ");
      ingredientsInProduitsResult?.forEach((ingredient) {
        ingredients.add(Ingredient.fromMap(ingredient));
      });
      final produitResult =
          await database?.query(Tables.produit.name, where: "id = $e");
      Map<String, Object?> map =
          Map<String, Object?>.from(produitResult?.first ?? {});
      map["ingredients"] = ingredients;
      produits.add(Produit.fromMap(map));
    }
    return produits;
  }

  static Future<List<T>?> findAll<T>(
      Tables table, T Function(Map<String, dynamic>) fromMap) async {
    final List<Map<String, Object?>>? maps = await database?.query(table.name);
    return maps?.map(fromMap).toList();
  }
}
