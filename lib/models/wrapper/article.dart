import 'package:collection/collection.dart';
import 'package:la_bonne_franquette_front/models/addon.dart';
import 'package:la_bonne_franquette_front/models/ingredient.dart';

class Article {
  final String name;
  int quantity;
  final int totalPrice;
  List<Ingredient> ingredients;
  List<Addon> addons;
  bool modified = false;

  Article({
    required this.name,
    required this.quantity,
    required this.totalPrice,
    required this.ingredients,
    required this.addons,
    modified,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    List<Ingredient> ingredients = [];
    if (json['ingredients'] != null) {
      json['ingredients'].forEach((ingredientJson) {
        ingredients.add(Ingredient.fromJson(ingredientJson));
      });
    }

    List<Addon> addons = [];
    if (json['addons'] != null) {
      json['addons'].forEach((extraJson) {
        addons.add(Addon.fromJson(extraJson));
      });
    }

    return Article(
        name: json['name'],
        quantity: json['quantity'],
        totalPrice: json['totalPrice'],
        ingredients: ingredients,
        addons: addons,
        modified: json['modified']);
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> ingredientsJson =
        ingredients.map((ingredient) => ingredient.toJson()).toList();
    List<Map<String, dynamic>> extraSetJson =
        addons.map((extra) => extra.toJson()).toList();
    return {
      'name': name,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'ingredients': ingredientsJson,
      'addons': extraSetJson,
      "modified": modified
    };
  }

  @override
  String toString() {
    return 'Article(name: $name, quantity: $quantity, totalPrice: $totalPrice, ingredients: $ingredients, addons: $addons, modified: $modified)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Article otherArticle = other as Article;
    return name == otherArticle.name &&
        ListEquality().equals(ingredients, otherArticle.ingredients) &&
        ListEquality().equals(addons, otherArticle.addons);
  }

  @override
  int get hashCode => Object.hash(
        name,
        ListEquality().hash(ingredients),
        ListEquality().hash(addons),
      );
}
