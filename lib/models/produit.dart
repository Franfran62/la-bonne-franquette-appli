import "package:la_bonne_franquette_front/models/categorie.dart";
import "package:la_bonne_franquette_front/models/interface/identifiable.dart";
import "package:la_bonne_franquette_front/services/stores/database_service.dart";
import "ingredient.dart";

class Produit implements Identifiable {

  @override
  final int id;
  @override
  final String nom;
  final int prixHt;
  final List<Ingredient> ingredients;
  final List<Categorie> categories;

  Produit ({
    required this.id,
    required this.nom,
    required this.prixHt,
    required this.ingredients,
    required this.categories,
  });

  factory Produit.fromJson(Map<String, dynamic> json) {
    try {
      var ingredientList = json['ingredientSet'] as List<dynamic>;
      var categorieList = json['categorieSet'] as List<dynamic>;

      List<Ingredient> ingredients = ingredientList
        .map((ingredientJson) => Ingredient.fromJson(ingredientJson))
        .toList();

      List<Categorie> categories = categorieList
        .map((categorieJson) => Categorie.fromJson(categorieJson))
        .toList();

      return Produit(
            id: json['id'] as int,
            nom: json['nom'] as String,
            prixHt: json['prixHT'] as int,
            ingredients: ingredients,
            categories: categories,
          ); 
    } catch (e) {
      throw Exception("Impossible de créer un Produit à partir de $json");
    }
  }

  static Produit fromMap(Map<String, dynamic> map) {
    return Produit(
      id: map['id'],
      nom: map['nom'],
      prixHt: map['prixht'],
      ingredients: map['ingredients'] ?? [],
      categories: map['categories'] ?? [],
    );
  }

  static Future<Produit?> fromId(int id) async {
    return await DatabaseService.getProduitById(id);
  }

  Map<String, dynamic> register () {
    return {
      "id": id,
      "nom": nom,
      "prixHT": prixHt,
    };
  }

  int getId() {
    return id;
  }

  String getNom() {
    return nom;
  }

  int getPrixHt() {
    return prixHt;
  }

  List<Ingredient> getIngredients() {
    return ingredients;
  }

  List<Categorie> getCategories() {
    return categories;
  }

 
}