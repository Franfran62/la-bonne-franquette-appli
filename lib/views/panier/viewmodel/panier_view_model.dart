import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:la_bonne_franquette_front/models/menu.dart';
import 'package:la_bonne_franquette_front/models/panier.dart';
import 'package:la_bonne_franquette_front/services/api/api_service.dart';

import '../../../models/produit.dart';

class PanierViewModel {
  static final PanierViewModel _singleton = PanierViewModel._internal();

  static List<Article> articles = [];
  List<Produit> produits = [];
  List<Menu> menus = [];
  double prixTotal = 0;

  factory PanierViewModel() {
    return _singleton;
  }

  PanierViewModel._internal();

  ValueNotifier<List<Article>> articlesNotifier =
      ValueNotifier<List<Article>>(articles);

  Future<bool> sendOrder() async {
    if (articles.isEmpty) {
      throw Exception("Le panier est vide.");
    }

    Map commandeBody = {
      "surPlace": true,
      "menus": [],
      "paiementSet": [],
      "status": "EN_COURS",
      "articles": articles.map((article) => article.toJson()).toList(),
      "prixHT": prixTotal * 100,
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
    return prixTotal;
  }

  void clearPanier() {
    print("clearing...");
    articles = [];
    produits = [];
    menus = [];
    prixTotal = 0;
    Future.microtask(() {
      articlesNotifier.value = articles;
    });
  }

  void ajouterArticle(Article article) {
    ajouterAuPanier(article);
  }
  
  void ajouterProduit(Produit produit) {
    print(produit.nom);
    produits.add(produit);
    print("produits:"+produits.length.toString());
    Article article = Article(
      nom: produit.nom,
      quantite: 1,
      prixHT: produit.prixHt,
      ingredients: [],
      extraSet: [],
    );
    ajouterAuPanier(article);
    articles.map((e) => print(e.nom+"\n"));
  }

  void ajouterMenu(Menu menu) {
    print(menu.produits.length.toString());
    menus.add(menu);
    for(var produit in menu.produits) {
      ajouterProduit(produit);
    }
  }

  void ajouterAuPanier(Article article) {
    Article? existingArticle = articles.firstWhereOrNull((a) {
      if(article.ingredients.isEmpty && article.extraSet.isEmpty) {
        return a.nom == article.nom && (a.ingredients.isEmpty && a.extraSet.isEmpty);
      } else if(article.ingredients.isEmpty && article.extraSet.isNotEmpty) {
        return a.nom == article.nom && a.extraSet == article.extraSet && a.ingredients.isEmpty;
      } else if(article.ingredients.isNotEmpty && article.extraSet.isEmpty) {
        return a.nom == article.nom && a.ingredients == article.ingredients && a.extraSet.isEmpty;
      } else {
        return a.nom == article.nom && a.ingredients == article.ingredients && a.extraSet == article.extraSet;
      }
    });
    if (existingArticle != null) {
      existingArticle.quantite += 1;
    } else {
      articles.add(article);
    }
    calculerLePrixTotal();
    print("");
    print("articles:"+articles.length.toString());
    Future.microtask(() {
      articlesNotifier.value = List.from(articles);
    });
  }

  void supprimerArticle(Article article) {
      Article? existingArticle = articles.firstWhereOrNull((a) {
        if(article.ingredients.isEmpty && article.extraSet.isEmpty) {
          return a.nom == article.nom && (a.ingredients.isEmpty && a.extraSet.isEmpty);
        } else if(article.ingredients.isEmpty && article.extraSet.isNotEmpty) {
          return a.nom == article.nom && a.extraSet == article.extraSet && a.ingredients.isEmpty;
        } else if(article.ingredients.isNotEmpty && article.extraSet.isEmpty) {
          return a.nom == article.nom && a.ingredients == article.ingredients && a.extraSet.isEmpty;
        } else {
          return a.nom == article.nom && a.ingredients == article.ingredients && a.extraSet == article.extraSet;
        }
      });

      if (existingArticle != null && existingArticle.quantite > 1) {
        existingArticle.quantite -= 1;
      } else {
        articles.remove(article);
      }
      calculerLePrixTotal();

    Future.microtask(() {
      articlesNotifier.value = List.from(articles);
    });
  }

  void calculerLePrixTotal() {
    prixTotal = articles.fold(
        0, (previousValue, element) =>
        previousValue + element.prixHT * element.quantite / 100);
  }
}
