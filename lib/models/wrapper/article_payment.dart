import 'package:la_bonne_franquette_front/models/wrapper/article.dart';
import 'package:la_bonne_franquette_front/models/order.dart';
import 'package:la_bonne_franquette_front/models/wrapper/selection.dart';

class ArticlePayment {
  final dynamic article;

  ArticlePayment({
    required this.article,
    bool? modified,
  });

  static List<ArticlePayment> build(Order commande) {
    List<ArticlePayment> list = [];
    for (var article in commande.articles) {
      for (int i = 0; i < article.quantity; i++) {
        list.add(ArticlePayment(
            article: Article(
          name: article.name,
          quantity: 1,
          totalPrice: article.totalPrice,
          ingredients: article.ingredients,
          addons: article.addons,
          modified: article.modified,
        )));
      }
    }
    for (var selection in commande.menus) {
      for (int i = 0; i < selection.quantity; i++) {
        list.add(ArticlePayment(
            article: Selection(
                name: selection.name,
                articles: selection.articles,
                quantity: 1,
                totalPrice: selection.totalPrice,
                modified: selection.modified)));
      }
    }
    return list;
  }

  static List<ArticlePayment> buildArticlePaiementPaid(Order commande) {
    List<ArticlePayment> list = [];
    for (var paiement in commande.payments) {
      for (var article in paiement.articles) {
        //article
        if (article.quantity > 1) {
          for (var i = 0; i < article.quantity; i++) {
            list.add(ArticlePayment(
                article: Article(
              name: article.name,
              quantity: 1,
              totalPrice: article.totalPrice,
              ingredients: article.ingredients,
              addons: article.addons,
              modified: article.modified,
            )));
          }
        } else {
          list.add(
              ArticlePayment(article: article, modified: article.modified));
        }
      }
      //selection
      for (var selection in paiement.selections) {
        if (selection.quantity > 1) {
          for (var i = 0; i < selection.quantity; i++) {
            list.add(ArticlePayment(
                article: Selection(
                    name: selection.name,
                    articles: selection.articles,
                    quantity: 1,
                    totalPrice: selection.totalPrice,
                    modified: selection.modified)));
          }
        } else {
          list.add(
              ArticlePayment(article: selection, modified: selection.modified));
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

  static List<Article> getArticles(List<ArticlePayment> articlesPaiement) {
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
        name: article.name,
        quantity: entry.value,
        totalPrice: article.totalPrice,
        ingredients: article.ingredients,
        addons: article.addons,
        modified: article.modified,
      );
    }).toList();
  }

  static List<Selection> getSelections(List<ArticlePayment> articlesPaiement) {
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
        name: selection.name,
        articles: selection.articles,
        quantity: entry.value,
        totalPrice: selection.totalPrice,
        modified: selection.modified,
      );
    }).toList();
  }

  @override
  String toString() {
    return 'ArticlePaiement(article: $article)';
  }
}
