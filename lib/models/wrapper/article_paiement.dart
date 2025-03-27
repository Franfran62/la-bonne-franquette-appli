import 'package:la_bonne_franquette_front/models/wrapper/article.dart';
import 'package:la_bonne_franquette_front/models/commande.dart';
import 'package:la_bonne_franquette_front/models/selection.dart';

class ArticlePaiement {
  final dynamic article;

  ArticlePaiement({
    required this.article,
    bool? isModified,
  });

  static List<ArticlePaiement> buildArticlePaiementList(Commande commande) {
    List<ArticlePaiement> list = [];
    for (var article in commande.articles) {
      for (int i = 0; i < article.quantite; i++) {
        list.add(ArticlePaiement(article: 
          Article(
            nom: article.nom,
            quantite: 1,
            prixTTC: article.prixTTC,
            ingredients: article.ingredients,
            extraSet: article.extraSet,
            isModified: article.isModified,
          )
        ));
      }
    }
    for (var selection in commande.menus) {
      for (int i = 0; i < selection.quantite; i++) {
        list.add(ArticlePaiement(article: 
          Selection(
            nom: selection.nom, 
            articles: selection.articles, 
            quantite: 1, 
            prixTTC: selection.prixTTC, 
            isModified: selection.isModified)
        ));
      }
    }
    return list;
  }

  static List<ArticlePaiement> buildArticlePaiementPaid(Commande commande) {
    List<ArticlePaiement> list = [];
    for (var paiement in commande.paiementSet) {

      for (var article in paiement.articles) {
        //article
        if (article.quantite > 1) {
          for (var i = 0; i < article.quantite; i++) {
            list.add(ArticlePaiement(article:
              Article(
                nom: article.nom,
                quantite: 1,
                prixTTC: article.prixTTC,
                ingredients: article.ingredients,
                extraSet: article.extraSet,
                isModified: article.isModified,
              )
            ));
          }
        } else {
          list.add(ArticlePaiement(article: article, isModified: article.isModified));
        }
      }
        //selection
        for (var selection in paiement.selections) {
          if (selection.quantite > 1) {
            for (var i = 0; i < selection.quantite; i++) {
              list.add(ArticlePaiement(article: 
                Selection(
                  nom: selection.nom, 
                  articles: selection.articles, 
                  quantite: 1, 
                  prixTTC: selection.prixTTC, 
                  isModified: selection.isModified)
              ));
            }
          } else {
            list.add(ArticlePaiement(article: selection, isModified: selection.isModified));
          }
        }
    }
    return list;
  }

  Article? getArticle() {
    return article is Article ? article as Article : null;
  }

  Selection? getSelection() {
    return article is Selection ? article as Selection : null;
  }

  static List<Article> getArticles(List<ArticlePaiement> articlesPaiement) {
  final Map<Article, int> fusionMap = {};

  for (var articlePaiement in articlesPaiement) {
    final article = articlePaiement.getArticle();
    if (article == null) continue;

    if (fusionMap.containsKey(article)) {
      fusionMap[article] = fusionMap[article]! + 1;
    } else {
      fusionMap[article] = 1;
    }
  }

  return fusionMap.entries.map((entry) {
    final article = entry.key;
    return Article(
      nom: article.nom,
      quantite: entry.value,
      prixTTC: article.prixTTC,
      ingredients: article.ingredients,
      extraSet: article.extraSet,
      isModified: article.isModified,
    );
  }).toList();
}


  static List<Selection> getSelections(List<ArticlePaiement> articlesPaiement) {
  final Map<Selection, int> fusionMap = {};

  for (var articlePaiement in articlesPaiement) {
    final selection = articlePaiement.getSelection();
    if (selection == null) continue;

    if (fusionMap.containsKey(selection)) {
      fusionMap[selection] = fusionMap[selection]! + 1;
    } else {
      fusionMap[selection] = 1;
    }
  }

  return fusionMap.entries.map((entry) {
    final selection = entry.key;
    return Selection(
      nom: selection.nom,
      articles: selection.articles,
      quantite: entry.value,
      prixTTC: selection.prixTTC,
      isModified: selection.isModified,
    );
  }).toList();
}

@override
String toString() {
  return 'ArticlePaiement(article: $article)';
}
}
