import 'package:la_bonne_franquette_front/models/extra.dart';

class Ingredient {
  final int id;
  final String nom;
  final bool aCuire;
  final Extra? extra;

  const Ingredient({
    required this.id,
    required this.nom,
    required this.aCuire,
    required this.extra,
  });

  
  
  factory Ingredient.fromJson(Map<String, dynamic> json){
    return switch (json) {
      {
        "id": int id,
        "nom": String nom,
        "acuire": bool aCuire,
        "extra": Extra extra,
      } => 
        Ingredient(id: id, nom: nom, aCuire: aCuire, extra: extra),
      {
        "id": int id,
        "nom": String nom,
        "acuire": bool aCuire,
      } =>
        Ingredient(id: id, nom: nom, aCuire: aCuire, extra: null),
        _ => throw Exception("Impossible de créer un Ingredient à partir de $json"),
    };
  }

  int getId() {
    return id;
  }

  String getNom() {
    return nom;
  }

  bool getACuire() {
    return aCuire;
  }

  Extra? getExtra() {
    return this.extra;
  }

}