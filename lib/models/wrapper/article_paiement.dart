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
        list.add(ArticlePaiement(article: article));
      }
    }
    for (var selection in commande.menus) {
      for (int i = 0; i < selection.quantite; i++) {
        list.add(ArticlePaiement(article: selection));
      }
    }
    return list;
  }

  static List<ArticlePaiement> buildArticlePaiementPaid(Commande commande) {
    List<ArticlePaiement> list = [];
    for (var paiement in commande.paiementSet) {
      for (var article in paiement.articles) {
        list.add(ArticlePaiement(article: article));
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
    return articlesPaiement
        .map<Article?>((e) => e.getArticle())
        .where((e) => e != null)
        .cast<Article>()
        .toList();
  }

  static List<Selection> getSelections(List<ArticlePaiement> articlesPaiement) {
    return articlesPaiement
        .map<Selection?>((e) => e.getSelection())
        .where((e) => e != null)
        .cast<Selection>()
        .toList();
  }
}
