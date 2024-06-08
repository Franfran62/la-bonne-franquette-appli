import 'dart:core';

import 'package:get_storage/get_storage.dart';
import 'package:la_bonne_franquette_front/models/categorie.dart';
import 'package:la_bonne_franquette_front/models/extra.dart';
import 'package:la_bonne_franquette_front/models/ingredient.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/models/sous_categorie.dart';
import 'package:la_bonne_franquette_front/services/api_service.dart';

class InitialisationService {


  /// Fonction permettant d'initialiser les ressources de l'application
  static void initStores() async {
    await GetStorage.init();

    await initStore<Ingredient>('ingredient');
    await initStore<Categorie>('categorie');
    //await initStore<SousCategorie>('souscategorie');
    await initStore<Extra>('extra');


    print(GetStorage().getKeys());
  }

  static Future<void> initStore<T>(String endpoint) async {
    
    print('fetching for $endpoint');

    final response = await ApiService().fetchAll(endpoint: endpoint, token: true);
    List<T> results = List<T>.empty(growable: true);

    print(results.isNotEmpty);

    switch (endpoint) {
      case "extra":
      //Extra
        for (var i in response){
          results.add(Extra.fromJson(i as Map<String, dynamic>) as T);
        }
      case "souscategorie":
      //SousCategorie
        for (var i in response){
          results.add(SousCategorie.fromJson(i as Map<String, dynamic>) as T);
        }
      case "categorie":
      //Categorie
        for (var i in response){
          results.add(Categorie.fromJson(i as Map<String, dynamic>) as T);
        }
      case "ingredient":
      //Ingredient
      print('fetching ingrdients');
        for (var i in response){
          results.add(Ingredient.fromJson(i as Map<String, dynamic>) as T);
        }
      case Produit _:
      //Produit
        print("undifined");
      default:
        throw Exception('Impossible d\'initialiser le store pour le modèle $T');
    }
    print(results.length);
    GetStorage().write("${endpoint}s", results);
  }
}