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

  const Categorie({
    required this.id,
    required this.nom,
    required this.categorieType,
    this.categorieId,
    this.produits = const [],
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'categorieType': categorieType,
      'categorieId': categorieId,
      'produits' : produits,
    };
  }

  int getId() {
    return id;
  }

  String getNom() {
    return nom;
  }


  String getCategorieType() {
    return categorieType;
  }

  int? getCategorieId() {
    return categorieId;
  }

  List<Produit> getProduits() {
    return produits;
  }
}