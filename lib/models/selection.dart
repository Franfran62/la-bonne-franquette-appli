import 'package:la_bonne_franquette_front/models/article.dart';

class Selection {
  final String nom;
  final List<Article> articles;
  int quantite;
  final int prixHT;

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
}