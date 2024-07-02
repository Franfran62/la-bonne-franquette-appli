import 'package:get_storage/get_storage.dart';
import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:la_bonne_franquette_front/services/api_service.dart';

class PanierViewModel {
  final GetStorage carte = GetStorage('carte');
  late List<Article> articles;

  PanierViewModel() {
    articles = carte.read('panier') ?? List<Article>.empty();
  }

  Future<bool> sendOrder() async {
    int prixTotal = getTotalPrice();
    Map commandeBody = {
      "numero": carte.read('commandeNumber'),
      "surPlace": true,
      "menus": [],
      "paiementSet": [],
      "status": "EN_COURS",
      "articles": articles.map((e) => e.toJsonNoIngredient()).toList(),
      "prixHT": prixTotal,
    };
    try {
      List<dynamic> response = await ApiService().post(endpoint: '/commandes', body: commandeBody, token: true);
      print(response);
    } on Exception {
      rethrow;
    }
    await clearPanier();
    carte.write('commandeNumber', carte.read('commandeNumber') + 1);
    return true;
  }

  Future<void> clearPanier() async {
    await carte.remove("panier");
    articles = List<Article>.empty();
  }

  int getTotalPrice() {
    int total = 0;
    for (var article in articles) {
      total += article.prixHT * article.quantite;
    }
    return total;
  }

  double getTotalPriceTTC() {
    return getTotalPrice() * 1.1;
  }
}
