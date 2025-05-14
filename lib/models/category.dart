import 'package:collection/collection.dart';
import 'package:la_bonne_franquette_front/models/interface/identifiable.dart';
import 'package:la_bonne_franquette_front/models/product.dart';

class Category implements Identifiable {
  @override
  final int id;
  @override
  final String name;
  final String categoryType;
  final int? parentCategoryId;
  final List<Product> products;
  final List<Category> subCategories;

  const Category({
    required this.id,
    required this.name,
    required this.categoryType,
    this.parentCategoryId,
    this.products = const [],
    this.subCategories = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "id": int id,
        "name": String name,
        "categoryType": String categoryType,
        "parentCategoryId": int? parentCategoryId,
        "products": List<Product> products,
      } =>
        Category(
            id: id,
            name: name,
            categoryType: categoryType,
            parentCategoryId: parentCategoryId,
            products: products),
      {
        "id": int id,
        "name": String name,
        "categoryType": String categoryType,
        "products": List<Product> products,
      } =>
        Category(
            id: id, name: name, categoryType: categoryType, products: products),
      {
        "id": int id,
        "name": String name,
        "categoryType": String categoryType,
        "parentCategoryId": int? parentCategoryId
      } =>
        Category(
            id: id,
            name: name,
            categoryType: categoryType,
            parentCategoryId: parentCategoryId),
      {
        "id": int id,
        "name": String name,
        "categoryType": String categoryType,
      } =>
        Category(id: id, name: name, categoryType: categoryType),
      _ =>
        throw Exception("Impossible de créer un Categorie à partir de $json"),
    };
  }

  static Category fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      categoryType: map['categoryType'],
      parentCategoryId: map['parentCategoryId'],
      products: map['products'],
      subCategories: map['sub-categories'] ?? [],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category &&
        other.id == id &&
        other.name == name &&
        other.categoryType == categoryType &&
        other.parentCategoryId == parentCategoryId &&
        ListEquality().equals(other.products, products) &&
        ListEquality().equals(other.subCategories, subCategories);
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        categoryType,
        parentCategoryId,
        ListEquality().hash(products),
        ListEquality().hash(subCategories),
      );
}
