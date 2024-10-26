import 'package:flutter/foundation.dart';
import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:la_bonne_franquette_front/models/panier.dart';
import 'package:la_bonne_franquette_front/services/api/api_service.dart';

class PanierViewModel {
  static final PanierViewModel _singleton = PanierViewModel._internal();

  factory PanierViewModel() {
    return _singleton;
  }

  PanierViewModel._internal();

  ValueNotifier<List<Article>> articlesNotifier =
      ValueNotifier<List<Article>>(Panier.articles);

  Future<bool> sendOrder() async {
    if (Panier.articles.isEmpty) {
      throw Exception("Le panier est vide.");
    }

    Map commandeBody = {
      "surPlace": true,
      "menus": [],
      "paiementSet": [],
      "status": "EN_COURS",
      "articles": Panier.articles.map((article) => article.toJson()).toList(),
      "prixHT": Panier.prixTotal * 100,
    };
    try {
      await ApiService.post(
          endpoint: '/commandes', body: commandeBody, token: true);
    } on Exception {
      rethrow;
    }
    clearPanier();
    return true;
  }

  List<Article> getArticles() {
    return articlesNotifier.value;
  }

  double getTotalPriceTTC() {
    return Panier.prixTotal;
  }

  void clearPanier() {
    Panier.viderLePanier();
    Future.microtask(() {
      articlesNotifier.value = Panier.articles;
    });
  }

  void ajouterArticle(Article article) {
    Panier.ajouterAuPanier(article);
    Future.microtask(() {
      articlesNotifier.value = List.from(Panier.articles);
    });
  }

  void supprimerArticle(Article article) {
    Panier.supprimerDuPanier(article);
    Future.microtask(() {
      articlesNotifier.value = List.from(Panier.articles);
    });
  }
}
