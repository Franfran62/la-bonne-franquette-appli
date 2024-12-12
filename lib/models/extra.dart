import 'ingredient.dart';

class Extra extends Ingredient {

  final int prixHT;

  const Extra({
    required super.id,
    required super.nom,
    required super.aCuire,
    required this.prixHT,
  });

  factory Extra.fromJson(Map<String, dynamic> json){
    return switch(json) {
      {
        "id": int id,
        "nom": String nom,
        "acuire": bool aCuire,
        "prixHT": int prixHT,
      } =>Extra(id: id, nom: nom, aCuire: aCuire, prixHT: prixHT),
      _ => throw Exception("Impossible de créer un Extra à partir de $json"),
    };
  }

  static Extra fromMap(Map<String, dynamic> map) {
    bool acuire = map["acuire"] == 1;
    return Extra(
      id: map['id'],
      nom: map['nom'],
      prixHT: map['prixht'],
      aCuire: acuire
    );
  }
   @override
     Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nom": nom,
      "aCuire": aCuire,
      "prixHT": prixHT,
    };
  }

  int getPrixHT() {
    return prixHT;
  }
  
}