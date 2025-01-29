import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:collection/collection.dart';

class Selection {
  String nom;
  List<Article> articles;
  int quantite;
  int prixHT;
  bool isModified;

  Selection({
    required this.nom,
    required this.articles,
    required this.quantite,
    required this.prixHT,
    required this.isModified
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
      isModified: json['isModified'],
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> articlesJson = articles.map((article) => article.toJson()).toList();
    return {
      'nom': nom,
      'articles': articlesJson,
      'quantite': quantite,
      'prixHT': prixHT,
      'isModified': isModified,
    };
  }

  void addArticle(Article article) {
    if (articles.contains(article)) {
      articles[articles.indexOf(article)].quantite++;
    } else {
      articles.add(article);
      if (article.isModified) {
        isModified = true;
      }
    }
    calculatePrice();
  }


  void removeArticleByIndex(int index) {
    if (articles[index].quantite > 1) {
      articles[index].quantite--;
    } else {
      articles.removeAt(index);
      isModified = articles.any((article) => article.isModified);
    }
    calculatePrice();
  }

  calculatePrice() {
    prixHT = articles.fold(0, (sum, article) => sum + article.prixHT * article.quantite);
  } 

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Selection otherSelection = other as Selection;
    return nom == otherSelection.nom &&
        ListEquality().equals(articles, otherSelection.articles) &&
        quantite == otherSelection.quantite &&
        prixHT == otherSelection.prixHT &&
        isModified == otherSelection.isModified;
  }

  @override
  int get hashCode => Object.hash(
        nom,
        ListEquality().hash(articles),
        quantite,
        prixHT,
        isModified,
      );
}