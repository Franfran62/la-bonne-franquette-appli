import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:la_bonne_franquette_front/models/enums/tables.dart';
import 'package:la_bonne_franquette_front/models/extra.dart';
import 'package:la_bonne_franquette_front/models/menu.dart';
import 'package:la_bonne_franquette_front/models/menuItem.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/services/stores/database_service.dart';
import 'package:la_bonne_franquette_front/views/panier/viewmodel/panier_view_model.dart';

import '../../../models/categorie.dart';

class CaisseViewModel {
  static final CaisseViewModel _singleton = CaisseViewModel._internal();

  factory CaisseViewModel() {
    return _singleton;
  }

  CaisseViewModel._internal();
  
    Future<List<Produit>?> getProduits() async {
      return await DatabaseService.findAllProduits();
    }

    Future<List<Menu>?> getMenus() async {
      return await DatabaseService.findAllMenus();
  }

    Future<List<Extra>>? getExtras() async {

      var resultat = await DatabaseService.findAll(Tables.extra, Extra.fromMap);
      if(resultat == null) {
        return <Extra>[];
      } else {
        return resultat;
      }
    }

    Future<List<Categorie>?> getCategorie() async {
      return await DatabaseService.findAllCategories();
    }

    void ajouterProduitAuPanier(Produit produit) {
      PanierViewModel().ajouterProduit(produit);
    }

    void ajouterMenuAuPanier(Menu menu, List<Produit> produits) {
      PanierViewModel().ajouterMenu(menu, produits);
    }
}