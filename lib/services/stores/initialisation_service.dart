import 'dart:core';

import 'package:la_bonne_franquette_front/models/categorie.dart';
import 'package:la_bonne_franquette_front/models/enums/tables.dart';
import 'package:la_bonne_franquette_front/models/extra.dart';
import 'package:la_bonne_franquette_front/models/ingredient.dart';
import 'package:la_bonne_franquette_front/models/interface/identifiable.dart';
import 'package:la_bonne_franquette_front/models/menu.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/services/api/api_service.dart';
import 'package:la_bonne_franquette_front/services/stores/database_service.dart';

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
    try {
      final response = await ApiService.fetchAll(endpoint: "/$endpoint", token: true);
      switch (endpoint) {
        case "ingredient":
          for (var i in response){
            i['acuire'] = i['acuire'] ? 1 : 0; 
            await DatabaseService.insert(Tables.ingredient, i as Map<String, dynamic>);
          }
          break;
        case "extra":
          for (var i in response){
            i['acuire'] = i['acuire'] ? 1 : 0; 
            await DatabaseService.insert(Tables.extra, i as Map<String, dynamic>);
          }
          break;
        case "categorie":
          for (var i in response){
            await DatabaseService.insert(Tables.categorie, i as Map<String, dynamic>);
          }
          break;
        case "produit":
          for (var i in response){
            Produit produit = Produit.fromJson(i);
            List<Categorie> categories = produit.getCategories();
            List<Ingredient> ingredients = produit.getIngredients();
            List<Extra> extras = produit.getExtras();

            await DatabaseService.insert(Tables.produit, produit.register());
            await link<Categorie>(Tables.produitAppartientCategorie, i['id'], categories);
            await link<Ingredient>(Tables.produitContientIngredient, i['id'], ingredients);
            await link<Extra>(Tables.produitContientExtra, i['id'], extras);
          }
          break;
        case "menu":
          for (var i in response) {
            Menu menu = await Menu.fromJson(i);
            await DatabaseService.insert(Tables.menu, {
              "id": menu.id,
              "nom": menu.nom,
              "prixHT": menu.prixHT,
            });
            for (var menuItem in menu.menuItemSet) {
              await DatabaseService.insert(Tables.menuItem, {
                "id": menuItem.id,
                "optional": menuItem.optional ? 1 : 0,
                "extraPriceHT": menuItem.extraPriceHT,
                "menu_id": menu.id,
              });
              for (var produit in menuItem.produitSet) {
                await DatabaseService.insert(Tables.menuItemContientProduit, {
                  "menu_item_id": menuItem.id,
                  "produit_id": produit.id,
                });
              }
            }
          }
          break;

        default:
          throw Exception('Impossible d\'initialiser le store pour le modèle $T');
      }
    } catch(e) {
      print(e);
      throw Exception(e);
    }
  }

  static Future<void> link<T extends Identifiable>(Tables table, int id, List<T> items) async {
    try {
        List<String> tableSplitted =table.name.split("_");
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