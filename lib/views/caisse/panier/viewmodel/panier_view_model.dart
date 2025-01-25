import 'dart:async';

import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:la_bonne_franquette_front/models/selection.dart';


class PanierViewModel {
  static final PanierViewModel _singleton = PanierViewModel._internal();

  static List<Article> articles = [];
  static List<Selection> menus = [];
  static bool surPlace = true;
  double prixTotal = 0;

  factory PanierViewModel() {
    return _singleton;
  }

  PanierViewModel._internal();

  ValueNotifier<List<Article>> articlesNotifier =
      ValueNotifier<List<Article>>(articles);

  ValueNotifier<List<Selection>> menusNotifier =
      ValueNotifier<List<Selection>>(menus);

  void init(bool surPlace) {
    PanierViewModel.surPlace = surPlace;
    clearPanier();
  }

  bool getSurPlace() {
    return PanierViewModel.surPlace;
  }

  bool updateSurplace() {
    return PanierViewModel.surPlace = !PanierViewModel.surPlace;
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

  void supprimerMenu(Selection menu) {
    Selection existingMenu = menus.firstWhere((m) => m == menu);
    if (existingMenu.quantite > 1) {
      existingMenu.quantite -= 1;
    } else {
      menus.remove(menu);
    }
    Future.microtask(() {
      menusNotifier.value = List.from(menus);
    });
    calculerLePrixTotal();
  }

  Future<void> ajouterMenu(Selection menu) async {
      if (menus.contains(menu)) {
        Selection existingMenu = menus.firstWhere((m) => m == menu);
        existingMenu.quantite += 1;
      } else {
        menus.add(menu);
      }
      Future.microtask(() {
        menusNotifier.value = List.from(menus);
      });
      calculerLePrixTotal();
  }

  void ajouterQuantiteMenu(Selection menu) {
    Selection existingMenu = menus.firstWhere((m) => m == menu);
    print(existingMenu);
    existingMenu.quantite += 1;
    Future.microtask(() {
      menusNotifier.value = List.from(menus);
    });
    calculerLePrixTotal();
  }

  void ajouterAuPanier(Article article) {
    if (articles.contains(article)) {
      Article existingArticle = articles.firstWhere((a) => a == article);
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
    Article existingArticle = articles.firstWhere((a) => a == article);
    if (existingArticle.quantite > 1) {
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

  void sendOrder() {
    
  }
}
