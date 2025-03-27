import 'package:collection/collection.dart';
import 'package:la_bonne_franquette_front/models/interface/identifiable.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';

class Categorie implements Identifiable {

  @override
  final int id;
  @override
  final String nom;
  final String categorieType;
  final int? categorieId; // id du parent
  final List<Produit> produits;
  final List<Categorie> sousCategories;

  const Categorie({
    required this.id,
    required this.nom,
    required this.categorieType,
    this.categorieId,
    this.produits = const [],
    this.sousCategories = const [],
  });

  factory Categorie.fromJson(Map<String, dynamic> json){
    return switch (json) {
      {
      "id": int id,
      "nom": String nom,
      "categorieType": String categorieType,
      "categorieId": int? categorieId,
      "produits": List<Produit> produits,
      } =>
          Categorie(id: id, nom: nom, categorieType: categorieType, categorieId: categorieId, produits: produits),
      {
      "id": int id,
      "nom": String nom,
      "categorieType": String categorieType,
      "produits": List<Produit> produits,
      } =>
          Categorie(id: id, nom: nom, categorieType: categorieType, produits: produits),
      {
        "id": int id,
        "nom": String nom,
        "categorieType": String categorieType,
        "categorieId": int? categorieId
      } => 
        Categorie(id: id, nom: nom, categorieType: categorieType, categorieId: categorieId),
      {
        "id": int id,
        "nom": String nom,
        "categorieType": String categorieType,
      } => 
        Categorie(id: id, nom: nom, categorieType: categorieType),
        _ => throw Exception("Impossible de créer un Categorie à partir de $json"),
    };
  }

  static Categorie fromMap(Map<String, dynamic> map) {
    return Categorie(
      id: map['id'],
      nom: map['nom'],
      categorieType: map['categorieType'],
      categorieId: map['categorieId'],
      produits: map['produits'],
      sousCategories: map['sousCategories'] != null ? map['souscategories'] : [],
    );
  }

  @override
bool operator ==(Object other) {
  if (identical(this, other)) return true;

  return other is Categorie &&
      other.id == id &&
      other.nom == nom &&
      other.categorieType == categorieType &&
      other.categorieId == categorieId &&
      ListEquality().equals(other.produits, produits) &&
      ListEquality().equals(other.sousCategories, sousCategories);
}

  @override
int get hashCode => Object.hash(
      id,
      nom,
      categorieType,
      categorieId,
      ListEquality().hash(produits),
      ListEquality().hash(sousCategories),
    );
}