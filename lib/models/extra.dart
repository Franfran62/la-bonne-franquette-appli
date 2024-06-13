import 'ingredient.dart';

class Extra extends Ingredient {

  final int prixHT;

  const Extra({
    required super.id,
    required super.nom,
    required super.aCuire,
    required this.prixHT,
    super.extra, //
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