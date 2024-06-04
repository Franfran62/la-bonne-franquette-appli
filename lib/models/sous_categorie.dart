import 'categorie.dart';

class SousCategorie extends Categorie{
  final int categorieId;

  const SousCategorie({
    required super.id,
    required super.nom,
    required this.categorieId,
    super.sousCategories = const [],
  });

  factory SousCategorie.fromJson(Map<String, dynamic> json){
    return switch (json) {
      {
        "id": int id,
        "nom": String nom,
        "categorie": int categorieId,
      } => SousCategorie(id: id, nom: nom, categorieId: categorieId),
      _ => throw Exception("Impossible de créer une SousCategorie à partir de $json"),
    };
  }

  int getCategorieId() {
    return categorieId;
  }
  
}