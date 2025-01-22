import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:collection/collection.dart';
import 'package:la_bonne_franquette_front/models/menu.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';

class Panier {
  static List<Article> articles = [];
  static List<Produit> produits = [];
  static List<Menu> menus = [];
  static double prixTotal = 0;

  static void ajouterProduit(Produit produit) {
    produits.add(produit);
    print("produits:"+produits.length.toString());
    Article article = Article(
      nom: produit.nom,
      quantite: 1,
      prixHT: produit.prixHt,
      ingredients: [],
      extraSet: [],
    );
    ajouterAuPanier(article);
    articles.map((e) => print(e.nom));
  }


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
    print("articles:"+articles.length.toString());
  }

  static void supprimerProduit(Produit produit) {
    produits.add(produit);
    produits.remove(produit);

    Article article = Article(
      nom: produit.nom,
      quantite: 1,
      prixHT: produit.prixHt,
      ingredients: [],
      extraSet: [],
    );
    supprimerDuPanier(article);
  }

  // static void supprimerMenu(Menu menu) {
  //   menus.remove(menu);
  //   for(var produit in menu.produits) {
  //     supprimerProduit(produit);
  //   }
  // }

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
    print("clearing...");
    articles = [];
    produits = [];
    menus = [];
    prixTotal = 0;
  }

  static void calculerLePrixTotal() {
    prixTotal = articles.fold(
        0,
        (previousValue, element) =>
            previousValue + element.prixHT * element.quantite / 100);
  }
}
