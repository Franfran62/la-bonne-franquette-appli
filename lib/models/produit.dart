import "package:la_bonne_franquette_front/models/categorie.dart";
import "package:la_bonne_franquette_front/models/interface/identifiable.dart";
import "package:la_bonne_franquette_front/services/stores/database_service.dart";
import "ingredient.dart";
import "extra.dart"; 

class Produit implements Identifiable {

  @override
  final int id;
  @override
  final String nom;
  final int prixTTC;
  final List<Ingredient> ingredients;
  final List<Categorie> categories;
  final List<Extra> extras; 

  Produit ({
    required this.id,
    required this.nom,
    required this.prixTTC,
    required this.ingredients,
    required this.categories,
    required this.extras, 
  });

  factory Produit.fromJson(Map<String, dynamic> json) {
    try {
      var ingredientList = json['ingredientSet'] as List<dynamic>;
      var categorieList = json['categorieSet'] as List<dynamic>;
      var extraList = json['extraSet'] as List<dynamic>; 

      List<Ingredient> ingredients = ingredientList
        .map((ingredientJson) => Ingredient.fromJson(ingredientJson))
        .toList();

      List<Categorie> categories = categorieList
        .map((categorieJson) => Categorie.fromJson(categorieJson))
        .toList();

      List<Extra> extras = extraList
        .map((extraJson) => Extra.fromJson(extraJson))
        .toList();

      return Produit(
            id: json['id'] as int,
            nom: json['nom'] as String,
            prixTTC: json['prixTTC'] as int,
            ingredients: ingredients,
            categories: categories,
            extras: extras, 
          ); 
    } catch (e) {
      throw Exception("Impossible de créer un Produit à partir de $json");
    }
  }

  static Produit fromMap(Map<String, dynamic> map) {
    return Produit(
      id: map['id'],
      nom: map['nom'],
      prixTTC: map['prixTTC'],
      ingredients: map['ingredients'] ?? [],
      categories: map['categories'] ?? [],
      extras: map['extras'] ?? [],
    );
  }

  Map<String, dynamic> register () {
    return {
      "id": id,
      "nom": nom,
      "prixTTC": prixTTC,
    };
  }

  int getId() {
    return id;
  }

  String getNom() {
    return nom;
  }

  int getprixTTC() {
    return prixTTC;
  }

  List<Ingredient> getIngredients() {
    return ingredients;
  }

  List<Categorie> getCategories() {
    return categories;
  }

  List<Extra> getExtras() {
    return extras;
  }
}