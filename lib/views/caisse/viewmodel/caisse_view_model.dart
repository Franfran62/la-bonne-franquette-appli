import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:la_bonne_franquette_front/models/enums/tables.dart';
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

    void ajouterAuPanier(Produit produit)  {
      Article article = Article(
        nom: produit.nom,
        quantite: 1,
        prixHT: produit.prixHt,
        ingredients: [],
        extraSet: [],
      );
      PanierViewModel().ajouterArticle(article);
    }
}