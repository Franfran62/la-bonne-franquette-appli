import 'dart:async';
import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:la_bonne_franquette_front/models/enums/tables.dart';
import 'package:la_bonne_franquette_front/models/extra.dart';
import 'package:la_bonne_franquette_front/models/ingredient.dart';
import 'package:la_bonne_franquette_front/models/menu.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/models/selection.dart';
import 'package:la_bonne_franquette_front/services/provider/commande_notifier.dart';
import 'package:la_bonne_franquette_front/services/stores/database_service.dart';
import 'package:la_bonne_franquette_front/views/caisse/widget/modification_modal.dart';
import '../../../models/categorie.dart';

class CaisseViewModel {
  static final CaisseViewModel _singleton = CaisseViewModel._internal();
  BuildContext? context;
  bool showModification = false;
  Selection menuEnConstruction = Selection(nom: "", articles: [], quantite: 1, prixHT: 0, isModified: false);
  CommandeNotifier commandeNotifier = CommandeNotifier();

  factory CaisseViewModel() {
    return _singleton;
  }

  CaisseViewModel._internal();

  void init(bool surPlace) {
    commandeNotifier.currentCommande.surPlace = surPlace;
    commandeNotifier.clearPanier();
    showModification = false;
    menuEnConstruction = Selection(nom: "", articles: [], quantite: 1, prixHT: 0, isModified: false);
  }

    bool getSurPlace() {
      return commandeNotifier.currentCommande.surPlace;
  }

    bool updateSurplace() {
    return commandeNotifier.currentCommande.surPlace = !commandeNotifier.currentCommande.surPlace;
  }

    Future<List<Menu>?> getMenus() async {
      return await DatabaseService.findAllMenus();
  }

    Future<List<Categorie>?> getCategorie() async {
      return await DatabaseService.findAllCategories();
    }

    void updateShowModification() {
      showModification = !showModification;
    }

    Future<void> ajouterProduitAuPanier(Produit produit) async {
      Map<String, List> modifications = {
        "ingredients": <Ingredient>[],
        "extras": <Extra>[]
      };

      if (showModification) {
        modifications = await displayModificationModal(produit);
      }

      Article article = Article(
        nom: produit.nom,
        quantite: 1,
        prixHT: produit.prixHt,
        ingredients: modifications["ingredients"] as List<Ingredient>,
        extraSet: modifications["extras"] as List<Extra>,
      );
      article.isModified =
        (article.extraSet.isNotEmpty || article.ingredients.isNotEmpty)
          ? true
          : false;

      commandeNotifier.addArticle(article);
      showModification = false;
    }

    void initMenuEnCours({String nom = ""}) {
      menuEnConstruction.articles = [];
      menuEnConstruction.nom = nom;
      menuEnConstruction.quantite = 1;  
      menuEnConstruction.prixHT = 0;
      menuEnConstruction.isModified = false;
    }

    Future<void> ajouterMenuEnCours(Produit produit) async {
      Map<String, List> modifications = {
        "ingredients": <Ingredient>[],
        "extras": <Extra>[]
      };
      if (showModification) {
        modifications = await displayModificationModal(produit);
      }
      Article article = Article(
        nom: produit.nom, 
        quantite: 1,
        prixHT: produit.prixHt, 
        ingredients:  modifications["ingredients"] as List<Ingredient>, 
        extraSet: modifications["extras"] as List<Extra>
      );
      article.isModified =
        (article.extraSet.isNotEmpty || article.ingredients.isNotEmpty)
          ? true
          : false;

      menuEnConstruction.addArticle(article);
      showModification = false;
    }

    void retirerMenuEnCours(int index) {
      menuEnConstruction.removeArticleByIndex(index);
    }

    void ajouterMenuAuPanier() async {
      Selection nouveauMenu = Selection(
        nom: menuEnConstruction.nom,
        articles:List.from(menuEnConstruction.articles),
        quantite: menuEnConstruction.quantite,
        prixHT: menuEnConstruction.prixHT,
        isModified: menuEnConstruction.isModified
      );
      commandeNotifier.addMenu(nouveauMenu);
      initMenuEnCours();
    }

    Future<Map<String, List>> displayModificationModal(Produit produit) async {
      Completer<Map<String, List>> modification = Completer();
      showDialog(
        context: context as BuildContext,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.2,
              horizontal: MediaQuery.of(context).size.width * 0.2,
            ),
            child: ModificationModal(
              produitAModifier: produit,
              onModificationsSelected: (modifications) {
                modification.complete(modifications);
                Navigator.pop(context);
              },
            ),
          );
        },
      );
      return modification.future;
    }
}