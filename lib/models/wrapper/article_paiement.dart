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

  Map<String, dynamic> toJson() {
    return article is Article ? (article as Article).toJson() : (article as Selection).toJson();
  }
}
