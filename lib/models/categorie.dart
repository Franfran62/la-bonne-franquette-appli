import 'sous_categorie.dart';

class Categorie {
  final int id;
  final String nom;
  final List<SousCategorie> sousCategories; //Liste des sous catégories de la catégorie

  const Categorie({
    required this.id,
    required this.nom,
    required this.sousCategories,
  });

  factory Categorie.fromJson(Map<String, dynamic> json){
    return switch (json) {
      {
        "id": int id,
        "nom": String nom,
        "sousCategories": List<SousCategorie> sousCategories,
      } => 
        Categorie(id: id, nom: nom, sousCategories: sousCategories),
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
}