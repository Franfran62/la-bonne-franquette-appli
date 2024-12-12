import 'package:la_bonne_franquette_front/models/interface/identifiable.dart';

class Ingredient implements Identifiable{

  @override
  final int id;
  @override
  final String nom;
  final bool aCuire;

  const Ingredient({
    required this.id,
    required this.nom,
    required this.aCuire,
  });

  
  
  factory Ingredient.fromJson(Map<String, dynamic> json){
    return switch (json) {
      {
        "id": int id,
        "nom": String nom,
        "acuire": bool aCuire,
      } => 
        Ingredient(id: id, nom: nom, aCuire: aCuire),
        _ => throw Exception("Impossible de créer un Ingredient à partir de $json"),
    };
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'id': id,
      'nom': nom,
      'aCuire': aCuire,
    };
    return json;
  }

  static Ingredient fromMap(Map<String, dynamic> map) {
    bool acuire = map["acuire"] == 1;
    return Ingredient(
      id: map['id'],
      nom: map['nom'],
      aCuire: acuire,
    );
  }

  @override
  String toString() {
    return 'Ingredient(id: $id, nom: $nom, aCuire: $aCuire)';
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

}
