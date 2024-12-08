import 'package:la_bonne_franquette_front/models/enums/tables.dart';
import 'package:la_bonne_franquette_front/models/extra.dart';
import 'package:la_bonne_franquette_front/models/menu.dart';
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

    Future<List<Extra>?> getExtras() async {
      return await DatabaseService.findAll(Tables.extra, Extra.fromMap);
    }

    Future<List<Categorie>?> getCategorie() async {
      return await DatabaseService.findAllCategories();
    }

    void ajouterProduitAuPanier(Produit produit) {
      print(produit.nom);
      PanierViewModel().ajouterProduit(produit);
    }

    void ajouterMenuAuPanier(Menu menu) {
      print(menu.nom);
      PanierViewModel().ajouterMenu(menu);
    }
}