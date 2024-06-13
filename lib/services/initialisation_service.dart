import 'dart:core';

import 'package:get_storage/get_storage.dart';
import 'package:la_bonne_franquette_front/models/categorie.dart';
import 'package:la_bonne_franquette_front/models/extra.dart';
import 'package:la_bonne_franquette_front/models/ingredient.dart';
import 'package:la_bonne_franquette_front/models/menu.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/models/sous_categorie.dart';
import 'package:la_bonne_franquette_front/services/api_service.dart';

class InitialisationService {

  static Future<void> initStores() async {
    await GetStorage.init('carte');
    await initStore<Ingredient>('ingredient');
    await initStore<Categorie>('categorie');
    //await initStore<SousCategorie>('souscategorie');
    await initStore<Extra>('extra');
    await initStore<Produit>('produit');
    await initStore<Menu>('menu');

    GetStorage carte = GetStorage("carte");
    print(carte.read("categorie"));
  }


  static Future<void> initStore<T>(String endpoint) async {    
    GetStorage carte = GetStorage("carte");

    final response = await ApiService().fetchAll(endpoint: "/$endpoint", token: true);
    List<T> results = List<T>.empty(growable: true);

    switch (endpoint) {
      case "extra":
        for (var i in response){
          results.add(Extra.fromJson(i as Map<String, dynamic>) as T);
        }
      case "souscategorie":
        for (var i in response){
          results.add(SousCategorie.fromJson(i as Map<String, dynamic>) as T);
        }
      case "categorie":
        for (var i in response){
          results.add(Categorie.fromJson(i as Map<String, dynamic>) as T);
        }
      case "ingredient":
        for (var i in response){
          results.add(Ingredient.fromJson(i as Map<String, dynamic>) as T);
        }
      case "produit":
        for (var i in response){
          Produit currentProduit = Produit.fromJson(i as Map<String, dynamic>);
          currentProduit.ingredients.map((i) => i.addProduit(currentProduit));
          currentProduit.categories.map((c) => c.addProduit(currentProduit));
          results.add(currentProduit as T);
        }
      case "menu":
        for (var i in response){
          results.add(Menu.fromJson(i as Map<String, dynamic>) as T);
        }
      default:
        throw Exception('Impossible d\'initialiser le store pour le modèle $T');
    }
    carte.write("${endpoint}s", results);
  }
}