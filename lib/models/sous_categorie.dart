import 'categorie.dart';

class SousCategorie extends Categorie{

  const SousCategorie({
    required super.id,
    required super.nom,
    super.sousCategories = const [],
    super.produits = const [],
  });

  factory SousCategorie.fromJson(Map<String, dynamic> json){
    return switch (json) {
      {
        "id": int id,
        "nom": String nom,
      } => SousCategorie(id: id, nom: nom),
      _ => throw Exception("Impossible de créer une SousCategorie à partir de $json"),
    };
  }
  
}