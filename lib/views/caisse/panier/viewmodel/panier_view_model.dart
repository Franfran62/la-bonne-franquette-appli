import 'dart:async';

import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:la_bonne_franquette_front/models/commande.dart';
import 'package:la_bonne_franquette_front/models/enums/statusCommande.dart';
import 'package:la_bonne_franquette_front/models/selection.dart';
import 'package:la_bonne_franquette_front/views/commande/viewmodel/commande_view_model.dart';
import 'package:provider/provider.dart';
import 'package:la_bonne_franquette_front/services/provider/commande_notifier.dart';

class PanierViewModel {
  static final PanierViewModel _singleton = PanierViewModel._internal();

  CommandeNotifier commandeNotifier = CommandeNotifier();

  factory PanierViewModel() {
    return _singleton;
  }

  PanierViewModel._internal();

  void init(bool surPlace) {
    commandeNotifier.currentCommande.surPlace = surPlace;
    clearPanier();
  }

  bool getSurPlace() {
    return commandeNotifier.currentCommande.surPlace ?? false;
  }

  bool updateSurplace() {
    return commandeNotifier.currentCommande.surPlace = !commandeNotifier.currentCommande.surPlace!;
  }

  void clearPanier() {
    commandeNotifier.clearPanier();
  }

  void supprimerMenu(Selection menu) {
    commandeNotifier.removeMenu(menu);
    calculerLePrixTotal();
  }

  Future<void> ajouterMenu(Selection menu) async {
    commandeNotifier.addMenu(menu);
    calculerLePrixTotal();
  }

  void ajouterQuantiteMenu(Selection menu) {
    commandeNotifier.addMenu(menu);
    calculerLePrixTotal();
  }

  void ajouterAuPanier(Article article) {
    commandeNotifier.addArticle(article);
    calculerLePrixTotal();
  }

  void supprimerArticle(Article article) {
    commandeNotifier.removeArticle(article);
    calculerLePrixTotal();
  }

  void calculerLePrixTotal() {
    commandeNotifier.calculerLePrixTotal();
  }
}