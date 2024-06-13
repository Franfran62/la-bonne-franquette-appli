import 'package:get_storage/get_storage.dart';
import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';

class CaisseViewModel {
    final GetStorage carte = GetStorage('carte');
    late List<Produit> produits;

    CaisseViewModel() {
      produits = carte.read('produits') ?? [];
    }
  
    Future<void> addToCart(Produit produit) async {
      //TODO: ajouter extra
      List<Article> panier = carte.read('panier') ?? [];
      
      panier.where((e) => e.nom == produit.nom).forEach((e) => e.quantite += 1);
      if(panier.where((e) => e.nom == produit.nom).isEmpty) {
        panier.add(Article(nom: produit.nom, quantite: 1, prixHT: produit.prixHt, ingredients: [], extraSet: []));
      }
      carte.write('panier', panier);
    }
  
}