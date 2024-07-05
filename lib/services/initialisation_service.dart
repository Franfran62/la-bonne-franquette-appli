import 'dart:core';

import 'package:la_bonne_franquette_front/models/categorie.dart';
import 'package:la_bonne_franquette_front/models/extra.dart';
import 'package:la_bonne_franquette_front/models/ingredient.dart';
import 'package:la_bonne_franquette_front/models/interface/identifiable.dart';
import 'package:la_bonne_franquette_front/models/menu.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/services/api_service.dart';
import 'package:la_bonne_franquette_front/services/database_service.dart';

class InitialisationService {

  static Future<void> initStores() async {
    await DatabaseService.initDatabase();
    await initStore<Ingredient>('ingredient');
    await initStore<Extra>('extra');
    await initStore<Categorie>('categorie');
    await initStore<Produit>('produit');
    await initStore<Menu>('menu');
    return;
  }

  static Future<void> initStore<T>(String endpoint) async {    
    final response = await ApiService().fetchAll(endpoint: "/$endpoint", token: true);
    switch (endpoint) {
      case "ingredient":
        for (var i in response){
          i['acuire'] = i['acuire'] ? 1 : 0; 
          await DatabaseService.insert("ingredient", i as Map<String, dynamic>);
        }
        break;
      case "extra":
        for (var i in response){
          i['acuire'] = i['acuire'] ? 1 : 0; 
          await DatabaseService.insert("extra", i as Map<String, dynamic>);
        }
        break;
      case "categorie":
        for (var i in response){
          await DatabaseService.insert("categorie", i as Map<String, dynamic>);
        }
        break;
      case "produit":
        for (var i in response){
          Produit produit = Produit.fromJson(i);
          List<Categorie> categories = produit.getCategories();
          List<Ingredient> ingredients = produit.getIngredients();

          await DatabaseService.insert("produit", produit.register());
          await link<Categorie>("produit_appartient_categorie", i['id'], categories);
          await link<Ingredient>("produit_contient_ingredient", i['id'], ingredients);
        }
        break;
      case "menu":
        for (var i in response){
          Menu menu = Menu.fromJson(i);
          List<Produit> produitsInMenu = menu.getProduits();

          await DatabaseService.insert("menu", menu.register());
          await link<Produit>("menu_contient_produit", i['id'], produitsInMenu);
        }
        break;
      default:
        throw Exception('Impossible d\'initialiser le store pour le modèle $T');
    }
  }

  static Future<void> link<T extends Identifiable>(String table, int id, List<T> items) async {
    try {
        List<String> tableSplitted =table.split("_");
        String referenceName = "${tableSplitted.first}_id";
        String itemName = "${tableSplitted.last}_id";

        for (T item in items) {
          await DatabaseService.insert(table, {
            referenceName: id,
            itemName: item.id 
          });
        }
    } catch(e) {
      throw Exception("Impossible de lier les éléments dans la table $table");
    }
  } 
}