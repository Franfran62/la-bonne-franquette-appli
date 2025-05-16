import 'package:la_bonne_franquette_front/models/wrapper/article.dart';
import 'package:collection/collection.dart';

class Selection {
  String name;
  List<Article> articles;
  int quantity;
  int totalPrice;
  bool modified;

  Selection({
    required this.name,
    required this.articles,
    required this.quantity,
    required this.totalPrice,
    required this.modified
  });

  factory Selection.fromJson(Map<String, dynamic> json) {
    List<Article> articles = [];
    if (json['articles'] != null) {
      json['articles'].forEach((articleJson) {
        articles.add(Article.fromJson(articleJson));
      });
    }
    return Selection(
      name: json['name'],
      articles: articles,
      quantity: json['quantity'],
      totalPrice: json['totalPrice'],
      modified: json['modified'],
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> articlesJson = articles.map((article) => article.toJson()).toList();
    return {
      'name': name,
      'articles': articlesJson,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'modified': modified,
    };
  }

  void addArticle(Article article) {
    if (articles.contains(article)) {
      articles[articles.indexOf(article)].quantity++;
    } else {
      articles.add(article);
      if (article.modified) {
        modified = true;
      }
    }
    calculatePrice();
  }


  void removeArticleByIndex(int index) {
    if (articles[index].quantity > 1) {
      articles[index].quantity--;
    } else {
      articles.removeAt(index);
      modified = articles.any((article) => article.modified);
    }
    calculatePrice();
  }

  calculatePrice() {
    totalPrice = articles.fold(0, (sum, article) => sum + article.totalPrice * article.quantity);
  } 

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Selection otherSelection = other as Selection;
    return name == otherSelection.name &&
        ListEquality().equals(articles, otherSelection.articles) &&
        quantity == otherSelection.quantity &&
        totalPrice == otherSelection.totalPrice &&
        modified == otherSelection.modified;
  }

  @override
  int get hashCode => Object.hash(
        name,
        ListEquality().hash(articles),
        quantity,
        totalPrice,
        modified,
      );
}