import 'package:la_bonne_franquette_front/models/produit.dart';

import 'sous_categorie.dart';

class Categorie {
  final int id;
  final String nom;
  final List<SousCategorie> sousCategories; //Liste des sous catégories de la catégorie
  final List<Produit>? produits;

  const Categorie({
    required this.id,
    required this.nom,
    required this.sousCategories,
    this.produits = const [],
  });

  factory Categorie.fromJson(Map<String, dynamic> json){
    return switch (json) {
      {
        "id": int id,
        "nom": String nom,
        "sousCategorieSet": List<SousCategorie> sousCategories,
      } => 
        Categorie(id: id, nom: nom, sousCategories: sousCategories),
      {
        'id': int id,
        'nom': String nom,
      } => Categorie(id: id, nom: nom, sousCategories: []),
        _ => throw Exception("Impossible de créer un Categorie à partir de $json"),
    };
  }

  int getId() {
    return id;
  }

  String getNom() {
    return nom;
  }

  List<SousCategorie> getSousCategories() {
    return sousCategories;
  }

  List<Produit>? getProduits() {
    return produits;
  }

  void addProduit(Produit produit) {
    produits!.add(produit);
  }
}