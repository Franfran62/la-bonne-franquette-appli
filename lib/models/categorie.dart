import 'package:la_bonne_franquette_front/models/interface/identifiable.dart';

class Categorie implements Identifiable {

  @override
  final int id;
  final String nom;
  final String categorieType;
  final int? categorieId;

  const Categorie({
    required this.id,
    required this.nom,
    required this.categorieType,
    this.categorieId
  });

  factory Categorie.fromJson(Map<String, dynamic> json){
    return switch (json) {
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'categorieType': categorieType,
      'categorieId': categorieId
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
}