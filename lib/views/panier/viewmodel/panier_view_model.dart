import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:la_bonne_franquette_front/models/menu.dart';
import 'package:la_bonne_franquette_front/models/selection.dart';
import 'package:la_bonne_franquette_front/services/api/api_service.dart';

import '../../../models/produit.dart';

class PanierViewModel {
  static final PanierViewModel _singleton = PanierViewModel._internal();

  static List<Article> articles = [];
  static List<Selection> menus = [];
  double prixTotal = 0;

  factory PanierViewModel() {
    return _singleton;
  }

  PanierViewModel._internal();

  ValueNotifier<List<Article>> articlesNotifier =
      ValueNotifier<List<Article>>(articles);

  ValueNotifier<List<Selection>> menusNotifier =
      ValueNotifier<List<Selection>>(menus);

  Future<bool> sendOrder() async {
    if (articles.isEmpty && menus.isEmpty) {
      throw Exception("Le panier est vide.");
    }

    Map commandeBody = {
      "surPlace": true,
      "menus": menus.map((menu) => menu.toJson()).toList(),
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

  List<Selection> getMenus() {
    return menusNotifier.value;
  }

  double getTotalPriceTTC() {
    return prixTotal;
  }

  void clearPanier() {
    articles = [];
    menus = [];
    prixTotal = 0;
    Future.microtask(() {
      menusNotifier.value = menus;
      articlesNotifier.value = articles;
    });
  }

  void ajouterArticle(Article article) {
    ajouterAuPanier(article);
  }

  void ajouterProduit(Produit produit) {
    Article article = Article(
      nom: produit.nom,
      quantite: 1,
      prixHT: produit.prixHt,
      ingredients: [],
      extraSet: [],
    );
    ajouterAuPanier(article);
  }

  void ajouterMenu(Menu menu) {
    List<Produit> produits = menu.produits;
    List<Article> articles = [];

    produits.forEach((p) {
      articles.add(Article(
          nom: p.nom,
          quantite: 1,
          prixHT: p.prixHt,
          ingredients: [],
          extraSet: []));
    });

    Selection menuCommande = Selection(
        nom: menu.nom, quantite: 1, articles: articles, prixHT: menu.prixHT);
    ajouterMenuAuPanier(menuCommande);
  }

  Article? findArticle(Article article) {
    return articles.firstWhereOrNull((a) {
      if (article.ingredients.isEmpty && article.extraSet.isEmpty) {
        return a.nom == article.nom &&
            (a.ingredients.isEmpty && a.extraSet.isEmpty);
      } else if (article.ingredients.isEmpty && article.extraSet.isNotEmpty) {
        return a.nom == article.nom &&
            a.extraSet == article.extraSet &&
            a.ingredients.isEmpty;
      } else if (article.ingredients.isNotEmpty && article.extraSet.isEmpty) {
        return a.nom == article.nom &&
            a.ingredients == article.ingredients &&
            a.extraSet.isEmpty;
      } else {
        return a.nom == article.nom &&
            a.ingredients == article.ingredients &&
            a.extraSet == article.extraSet;
      }
    });
  }

  Selection? findMenu(Selection menuCommande) {
    return menus.firstWhereOrNull((m) {
      if (m.articles.length != menuCommande.articles.length) {
        return false;
      }
      for (int i = 0; i < m.articles.length; i++) {
        Article article1 = m.articles[i];
        Article article2 = menuCommande.articles[i];
        if (article1.nom != article2.nom ||
            !ListEquality()
                .equals(article1.ingredients, article2.ingredients) ||
            !ListEquality().equals(article1.extraSet, article2.extraSet)) {
          return false;
        }
      }
      return true;
    });
  }

  void ajouterMenuAuPanier(Selection menuCommande) {
    Selection? existingMenu = findMenu(menuCommande);
    if (existingMenu != null) {
      existingMenu.quantite += 1;
    } else {
      menus.add(menuCommande);
    }
    Future.microtask(() {
      menusNotifier.value = List.from(menus);
    });
    calculerLePrixTotal();
  }

  void supprimerMenu(Selection menuCommande) {
    Selection? existingMenu = findMenu(menuCommande);

    if (existingMenu != null && existingMenu.quantite > 1) {
      existingMenu.quantite -= 1;
    } else {
      menus.remove(menuCommande);
    }
    Future.microtask(() {
      menusNotifier.value = List.from(menus);
    });
  }

  void ajouterAuPanier(Article article) {
    Article? existingArticle = findArticle(article);
    if (existingArticle != null) {
      existingArticle.quantite += 1;
    } else {
      articles.add(article);
    }
    Future.microtask(() {
      articlesNotifier.value = List.from(articles);
    });
    calculerLePrixTotal();
  }

  void supprimerArticle(Article article) {
    Article? existingArticle = findArticle(article);
    if (existingArticle != null && existingArticle.quantite > 1) {
      existingArticle.quantite -= 1;
    } else {
      articles.remove(article);
    }
    Future.microtask(() {
      articlesNotifier.value = List.from(articles);
    });
    calculerLePrixTotal();
  }

  void calculerLePrixTotal() {
    prixTotal = articles.fold(
        0,
        (previousValue, element) =>
            previousValue + element.prixHT * element.quantite / 100);
    prixTotal += menus.fold(
        0,
        (previousValue, element) =>
            previousValue + element.prixHT * element.quantite / 100);
  }
}
