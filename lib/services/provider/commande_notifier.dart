import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:la_bonne_franquette_front/models/commande.dart';
import 'package:la_bonne_franquette_front/models/enums/statusCommande.dart';
import 'package:la_bonne_franquette_front/models/selection.dart';

class CommandeNotifier extends ChangeNotifier {
  
  static final CommandeNotifier _singleton = CommandeNotifier._internal();

  static Commande _currentCommande = Commande(surPlace: true, articles: [], menus: [], paiementSet: [], status: StatusCommande.EN_COURS);

  factory CommandeNotifier() {
    return _singleton;
  }

  CommandeNotifier._internal() {
    _currentCommande = Commande(
      surPlace: true, 
      articles: [], 
      menus: [], 
      paiementSet: [],
      status: StatusCommande.EN_COURS
      );
  }

    void reset() {
    _currentCommande = Commande(
      commandeId: null,
      numero: null,
      surPlace: true, 
      articles: [], 
      menus: [], 
      paiementSet: [],
      status: StatusCommande.EN_COURS,
      prixHT: 0
      );
    calculerLePrixTotal();
  }

  Commande get currentCommande {
    return _currentCommande;
  }

  set currentCommande(Commande commande) {
    _currentCommande = commande;
    calculerLePrixTotal();
  }

  void addArticle(Article article) {
    if (_currentCommande.articles.contains(article)) {
      Article existingArticle = _currentCommande.articles.firstWhere((a) => a == article);
      existingArticle.quantite += 1;
    } else {
      _currentCommande.articles.add(article);
    }
    calculerLePrixTotal();
  }

  void addMenu(Selection menu) {
    if (_currentCommande.menus.contains(menu)) {
      Selection existingMenu = _currentCommande.menus.firstWhere((m) => m == menu);
      existingMenu.quantite += 1;
    } else {
      _currentCommande.menus.add(menu);
    }
    calculerLePrixTotal();
  }

  void removeArticle(Article article) {
    Article existingArticle = _currentCommande.articles.firstWhere((a) => a == article);
    if (existingArticle.quantite > 1) {
      existingArticle.quantite -= 1;
    } else {
      _currentCommande.articles.remove(article);
    }
    calculerLePrixTotal();
  }

  void removeMenu(Selection menu) {
    Selection existingMenu = _currentCommande.menus.firstWhere((m) => m == menu);
    if (existingMenu.quantite > 1) {
      existingMenu.quantite -= 1;
    } else {
      _currentCommande.menus.remove(menu);
    }
    calculerLePrixTotal();
  }

  void calculerLePrixTotal() {
    _currentCommande.prixHT = _currentCommande.articles.fold(
        0,
        (previousValue, element) =>
            (previousValue ?? 0) + element.prixHT * element.quantite);
    _currentCommande.prixHT = (_currentCommande.prixHT ?? 0) + _currentCommande.menus.fold(
        0,
        (previousValue, element) =>
            previousValue + element.prixHT * element.quantite);
    notifyListeners();
  }
}
