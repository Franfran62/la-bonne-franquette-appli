import 'package:la_bonne_franquette_front/models/enums/tables.dart';
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
    final List<Map<String, Object?>>? result = await database?.query(Tables.menu.name, columns: ["id"]);
    List<int> menuIDs = result?.map((e) => e.values.first as int).toList() ?? [];

    for (int e in menuIDs) {
      final List<Map<String, Object?>>? produitsInMenu = await database?.query(Tables.menuContientProduit.name, where: "menu_id = $e");
      List<int> produitIDs = produitsInMenu?.map((e) => e["produit_id"] as int).toList() ?? [];
      for (var f in produitIDs) print("menu id $e -> $f");

      List<Produit> produits = [];

      for(int i in produitIDs) {
        final List<Map<String, Object?>>? produitsList = await database?.query(Tables.produit.name, where: "id = $i");

        produitsList?.forEach((produit) {
          produits.add(Produit.fromMap(produit));
        });
      }

      final List<Map<String, Object?>>? maps = await database?.query(Tables.menu.name, where: "id = $e");
      Map<String, Object?> map = Map<String, Object?>.from(maps?.first ?? {});

      map["produits"] = produits;
      menus.add(Menu.fromMap(map));
    }

    return menus;
  }
  
static Future<List<T>?> findAll<T>(Tables table, T Function(Map<String, dynamic>) fromMap) async {
  final List<Map<String, Object?>>? maps = await database?.query(table.name);
  return maps?.map(fromMap).toList();
}
}