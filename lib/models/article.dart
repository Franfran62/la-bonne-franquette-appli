import 'package:la_bonne_franquette_front/models/extra.dart';
import 'package:la_bonne_franquette_front/models/ingredient.dart';

class Article {
  final String nom;
  int quantite;
  final int prixHT;
  final List<Ingredient> ingredients;
  final List<Extra> extraSet;

  Article({
    required this.nom,
    required this.quantite,
    required this.prixHT,
    required this.ingredients,
    required this.extraSet,
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
      prixHT: json['prixHT'],
      ingredients: ingredients,
      extraSet: extraSet,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> ingredientsJson = ingredients.map((ingredient) => ingredient.toJson()).toList();
    List<Map<String, dynamic>> extraSetJson = extraSet.map((extra) => extra.toJson()).toList();
    return {
      'nom': nom,
      'quantite': quantite,
      'prixHT': prixHT,
      'ingredients': ingredientsJson,
      'extraSet': extraSetJson,
    };
  }

  Map<String, dynamic> toJsonNoIngredient() {
    return {
      'nom': nom,
      'quantite': quantite,
      'prixHT': prixHT,
      'ingredients': [],
      'extraSet': extraSet.map((e) => e.toJson()).toList(),
    };
  } 

  @override
  String toString() {
    return 'Article(nom: $nom, quantite: $quantite, prixHT: $prixHT, ingredients: $ingredients, extraSet: $extraSet)';
  }

  double getPriceTTC(){
    return (prixHT/100)*1.1;
  }
}