import "package:collection/collection.dart";
import "package:la_bonne_franquette_front/models/category.dart";
import "package:la_bonne_franquette_front/models/interface/identifiable.dart";
import "package:la_bonne_franquette_front/services/stores/database_request.dart";
import "ingredient.dart";
import "addon.dart";

class Product implements Identifiable {
  @override
  final int id;
  @override
  final String name;
  final int totalPrice;
  final List<Ingredient> ingredients;
  final List<Category> categories;
  final List<Addon> addons;

  Product({
    required this.id,
    required this.name,
    required this.totalPrice,
    required this.ingredients,
    required this.categories,
    required this.addons,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      var ingredientList = json['ingredients'] as List<dynamic>;
      var categorieList = json['categories'] as List<dynamic>;
      var extraList = json['addons'] as List<dynamic>;

      List<Ingredient> ingredients = ingredientList
          .map((ingredientJson) => Ingredient.fromJson(ingredientJson))
          .toList();

      List<Category> categories = categorieList
          .map((categorieJson) => Category.fromJson(categorieJson))
          .toList();

      List<Addon> addons =
          extraList.map((extraJson) => Addon.fromJson(extraJson)).toList();

      return Product(
        id: json['id'] as int,
        name: json['name'] as String,
        totalPrice: json['totalPrice'] as int,
        ingredients: ingredients,
        categories: categories,
        addons: addons,
      );
    } catch (e) {
      throw Exception("Impossible de créer un Produit à partir de $json");
    }
  }

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      totalPrice: map['totalPrice'],
      ingredients: map['ingredients'] ?? [],
      categories: map['categories'] ?? [],
      addons: map['addons'] ?? [],
    );
  }

  Map<String, dynamic> register() {
    return {
      "id": id,
      "name": name,
      "totalPrice": totalPrice,
    };
  }

  int getId() {
    return id;
  }

  String getName() {
    return name;
  }

  int getTotalPrice() {
    return totalPrice;
  }

  List<Ingredient> getIngredients() {
    return ingredients;
  }

  List<Category> getCategories() {
    return categories;
  }

  List<Addon> getAddons() {
    return addons;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Product otherProduit = other as Product;
    return id == otherProduit.id &&
        name == otherProduit.name &&
        totalPrice == otherProduit.totalPrice &&
        ListEquality().equals(ingredients, otherProduit.ingredients) &&
        ListEquality().equals(categories, otherProduit.categories) &&
        ListEquality().equals(addons, otherProduit.addons);
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        totalPrice,
        ListEquality().hash(ingredients),
        ListEquality().hash(categories),
        ListEquality().hash(addons),
      );
}
