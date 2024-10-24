import 'package:la_bonne_franquette_front/models/enums/tables.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

static Future<List<T>?> findAll<T>(Tables table, T Function(Map<String, dynamic>) fromMap) async {
  final List<Map<String, Object?>>? maps = await database?.query(table.name);
  return maps?.map(fromMap).toList();
}
}