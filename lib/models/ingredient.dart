import 'package:la_bonne_franquette_front/models/interface/identifiable.dart';

class Ingredient implements Identifiable{

  @override
  final int id;
  @override
  final String nom;

  const Ingredient({
    required this.id,
    required this.nom,
  });

  
  
  factory Ingredient.fromJson(Map<String, dynamic> json){
    return switch (json) {
      {
        "id": int id,
        "nom": String nom,
      } => 
        Ingredient(id: id, nom: nom),
        _ => throw Exception("Impossible de créer un Ingredient à partir de $json"),
    };
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'id': id,
      'nom': nom,

    };
    return json;
  }

  static Ingredient fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['id'],
      nom: map['nom'],
    );
  }

  @override
  String toString() {
    return 'Ingredient(id: $id, nom: $nom)';
  }
  int getId() {
    return id;
  }

  String getNom() {
    return nom;
  }

  @override
  bool operator == (Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final Ingredient otherIngredient = other as Ingredient;

    return other.id == id && other.nom == nom;
  }

  @override
  int get hashCode => Object.hash(id, nom);
  
}
