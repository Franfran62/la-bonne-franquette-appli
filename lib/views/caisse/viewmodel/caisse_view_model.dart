import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:la_bonne_franquette_front/models/enums/tables.dart';
import 'package:la_bonne_franquette_front/models/menu.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/services/stores/database_service.dart';
import 'package:la_bonne_franquette_front/views/panier/viewmodel/panier_view_model.dart';

class CaisseViewModel {
  static final CaisseViewModel _singleton = CaisseViewModel._internal();

  factory CaisseViewModel() {
    return _singleton;
  }

  CaisseViewModel._internal();
  
    Future<List<Produit>?> getProduits() async {
      return await DatabaseService.findAll<Produit>(Tables.produit, Produit.fromMap);
    }

    Future<List<Menu>?> getMenus() async {
      return await DatabaseService.findAll<Menu>(Tables.menu, Menu.fromMap);
    }

    void ajouterProduitAuPanier(Produit produit) {
      print(produit.nom);
      PanierViewModel().ajouterProduit(produit);
    }

    void ajouterMenuAuPanier(Menu menu) {
      PanierViewModel().ajouterMenu(menu);
    }
}