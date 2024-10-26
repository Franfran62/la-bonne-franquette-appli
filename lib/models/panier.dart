import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:collection/collection.dart';

class Panier {
  static List<Article> articles = [];
  static double prixTotal = 0;



  static void ajouterAuPanier(Article article) {
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
  }

  static void supprimerDuPanier(Article article) {
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
  }

  static void viderLePanier() {
    articles = [];
    prixTotal = 0;
  }

  static void calculerLePrixTotal() {
    prixTotal = articles.fold(
        0,
        (previousValue, element) =>
            previousValue + element.prixHT * element.quantite / 100);
  }
}
