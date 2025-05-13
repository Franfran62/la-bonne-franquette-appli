import 'package:collection/collection.dart';
import 'package:la_bonne_franquette_front/models/extra.dart';
import 'package:la_bonne_franquette_front/models/ingredient.dart';

class Article {
  final String nom;
  int quantite;
  final int prixTTC;
  List<Ingredient> ingredients;
  List<Extra> extraSet;
  bool isModified = false;

  Article({
    required this.nom,
    required this.quantite,
    required this.prixTTC,
    required this.ingredients,
    required this.extraSet,
    isModified,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    List<Ingredient> ingredients = [];
    if (json['ingredients'] != null) {
      json['ingredients'].forEach((ingredientJson) {
        ingredients.add(Ingredient.fromJson(ingredientJson));
      });
    }

    List<Extra> extraSet = [];
    if (json['extraSet'] != null) {
      json['extraSet'].forEach((extraJson) {
        extraSet.add(Extra.fromJson(extraJson));
      });
    }

    return Article(
      nom: json['nom'],
      quantite: json['quantite'],
      prixTTC: json['prixTTC'],
      ingredients: ingredients,
      extraSet: extraSet,
      isModified: json['modified']
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> ingredientsJson = ingredients.map((ingredient) => ingredient.toJson()).toList();
    List<Map<String, dynamic>> extraSetJson = extraSet.map((extra) => extra.toJson()).toList();
    return {
      'nom': nom,
      'quantite': quantite,
      'prixTTC': prixTTC,
      'ingredients': ingredientsJson,
      'extraSet': extraSetJson,
      "modified": isModified
    };
  }

  @override
  String toString() {
    return 'Article(nom: $nom, quantite: $quantite, prixTTC: $prixTTC, ingredients: $ingredients, extraSet: $extraSet, isModified: $isModified)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Article otherArticle = other as Article;
    return nom == otherArticle.nom &&
        ListEquality().equals(ingredients, otherArticle.ingredients) &&
        ListEquality().equals(extraSet, otherArticle.extraSet);
  }

  @override
  int get hashCode => Object.hash(
        nom,
        ListEquality().hash(ingredients),
        ListEquality().hash(extraSet),
      );
}