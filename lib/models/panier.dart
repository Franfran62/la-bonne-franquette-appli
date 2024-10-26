import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:collection/collection.dart';

class Panier {
  static List<Article> articles = [];
  static double prixTotal = 0;

  static void ajouterAuPanier(Article article) {
    Article? existingArticle = articles.firstWhereOrNull((a) =>
        a.nom == article.nom &&
        (article.ingredients.isEmpty || a.ingredients == article.ingredients) &&
        (article.extraSet.isEmpty || a.extraSet == article.extraSet));
    if (existingArticle != null) {
      existingArticle.quantite += 1;
    } else {
      articles.add(article);
    }
    calculerLePrixTotal();
  }

  static void supprimerDuPanier(Article article) {
    Article? existingArticle = articles.firstWhereOrNull((a) =>
        a.nom == article.nom &&
        (article.ingredients.isEmpty || a.ingredients == article.ingredients) &&
        (article.extraSet.isEmpty || a.extraSet == article.extraSet));

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
