import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:la_bonne_franquette_front/models/panier.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/services/stores/database_service.dart';

class CaisseViewModel {
  
    Future<List<Produit>?> getProduits() async {
      return await DatabaseService.findAll<Produit>("produit", Produit.fromMap);
    }

    void ajouterAuPanier(Produit produit)  {
      Article article = Article(
        nom: produit.nom,
        quantite: 1,
        prixHT: produit.prixHt,
        ingredients: [],
        extraSet: [],
      );
      Panier.ajouterAuPanier(article);
    }
}