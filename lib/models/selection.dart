import 'package:la_bonne_franquette_front/models/article.dart';

class Selection {
  String nom;
  List<Article> articles;
  int quantite;
  int prixHT;

  Selection({
    required this.nom,
    required this.articles,
    required this.quantite,
    required this.prixHT,
  });

  factory Selection.fromJson(Map<String, dynamic> json) {
    List<Article> articles = [];
    if (json['articles'] != null) {
      json['articles'].forEach((articleJson) {
        articles.add(Article.fromJson(articleJson));
      });
    }
    return Selection(
      nom: json['nom'],
      articles: articles,
      quantite: json['quantite'],
      prixHT: json['prixHT'],
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> articlesJson = articles.map((article) => article.toJson()).toList();
    return {
      'nom': nom,
      'articles': articlesJson,
      'quantite': quantite,
      'prixHT': prixHT,
    };
  }

  void addArticle(Article article) {
    if (articles.contains(article)) {
      articles[articles.indexOf(article)].quantite++;
    } else {
    articles.add(article);
    }
    calculatePrice();
  }


  void removeArticleByIndex(int index) {
    if (articles[index].quantite > 1) {
      articles[index].quantite--;
    } else {
    articles.removeAt(index);
    }
    calculatePrice();
  }

  calculatePrice() {
    prixHT = articles.fold(0, (sum, article) => sum + article.prixHT * article.quantite);
  } 
}