import "package:get_storage/get_storage.dart";
import "package:la_bonne_franquette_front/models/categorie.dart";
import "package:la_bonne_franquette_front/models/sous_categorie.dart";

import "ingredient.dart";

class Produit {

  static final GetStorage carte = GetStorage("carte");

  final int id;
  final String nom;
  final int prixHt;
  List<Ingredient> ingredients;
  List<Categorie> categories;
  List<SousCategorie>? sousCategories;

  Produit ({
    required this.id,
    required this.nom,
    required this.prixHt,
    required this.ingredients,
    required this.categories,
    this.sousCategories,
  });

  factory Produit.fromJson(Map<String, dynamic> json) {
    List<Ingredient> ingredientsResults = [];
    List<Categorie> categorieResults = [];
    var ingredientsFromJson = json['ingredientSet'] as List; 
    var categoriesFromJson = json['categorieSet'] as List;
    ingredientsFromJson.map((ingredient) => ingredientsResults.add(carte.read('ingredients').firstWhere((element) => element.id == ingredient['id']) as Ingredient));
    categoriesFromJson.map((categorie) => categorieResults.add(carte.read('categories').firstWhere((element) => element.id == categorie['id']) as Categorie));

    return switch(json) {
      {
        "id": int id,
        "nom": String nom,
        "prixHT": int prixHT,
        "ingredientSet": List<dynamic> ingredients,
        "categorieSet": List<dynamic> categories,
        "sousCategorieSet": List<dynamic> sousCategories,
      } => Produit( id: id, 
                    nom: nom,
                    prixHt: prixHT,
                    ingredients: ingredients.map((e) => carte.read('ingredients').firstWhere((element) => element.id == e)).toList() as List<Ingredient>,
                    categories: categories.map((e) => carte.read('categories').firstWhere((element) => element.id == e)).toList() as List<Categorie>,
                    sousCategories: sousCategories.map((e) => carte.read('souscategories').firstWhere((element) => element.id == e)).toList() as List<SousCategorie>?,),
      {
        "id": int id,
        "nom": String nom,
        "prixHT": int prixHT,
        "categorieSet": List<dynamic> categories,
        "ingredientSet": List<dynamic> ingredients,
      } => Produit( id: id, 
                    nom: nom,
                    prixHt: prixHT,
                    ingredients: ingredientsResults,
                    categories: categorieResults,
                    sousCategories: null,),    
      _ => throw Exception("Impossible de créer un Produit à partir de $json"),
    };
  }

  double convertPriceToLong(){
    return prixHt / 100;
  }

  double getTTC(){
    return (prixHt * 1.1) / 100;
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

  List<SousCategorie>? getSousCategories() {
    return sousCategories;
  }

  
}