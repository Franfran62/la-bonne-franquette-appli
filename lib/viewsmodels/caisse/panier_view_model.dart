import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:la_bonne_franquette_front/models/panier.dart';
import 'package:la_bonne_franquette_front/services/api_service.dart';

class PanierViewModel {

  Future<bool> sendOrder() async {

    Map commandeBody = {
      "surPlace": true,
      "menus": [],
      "paiementSet": [],
      "status": "EN_COURS",
      "articles": Panier.articles.map((article) => article.toJson()).toList(),
      "prixHT": Panier.prixTotal*100,
    };
    try {
      await ApiService.postCommande(endpoint: '/commandes', body: commandeBody, token: true);
    } on Exception {
      rethrow;
    }
    clearPanier();
    return true;
  }

  List<Article> getArticles() {
    return Panier.articles;
  }

  double getTotalPriceTTC() {
    return Panier.prixTotal;
  }

  void clearPanier() {
    Panier.viderLePanier();
  }
}
