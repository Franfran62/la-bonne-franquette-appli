import 'ingredient.dart';

class Extra extends Ingredient {

  final int ingredientId;

  const Extra({
    required super.id,
    required super.nom,
    required super.aCuire,
    required this.ingredientId,
    super.extras = const [], //
  });

  factory Extra.fromJson(Map<String, dynamic> json){
    return switch(json) {
      {
        "id": int id,
        "nom": String nom,
        "aCuire": bool aCuire,
        "ingredient": int ingredientId,
      } =>Extra(id: id, nom: nom, aCuire: aCuire, ingredientId: ingredientId),
      _ => throw Exception("Impossible de créer un Extra à partir de $json"),
    };
  }

  int getIngredientId() {
    return this.ingredientId;
  }
  
}