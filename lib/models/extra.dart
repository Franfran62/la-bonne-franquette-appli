import 'package:la_bonne_franquette_front/models/interface/identifiable.dart';

import 'ingredient.dart';

class Extra implements Identifiable {

  @override
  final int id;
  @override
  final String nom;
  final int prixTTC;

  const Extra({
    required this.id,
    required this.nom,
    required this.prixTTC,
  });

  factory Extra.fromJson(Map<String, dynamic> json){
    return switch(json) {
      {
        "id": int id,
        "nom": String nom,
        "prixTTC": int prixTTC,
      } =>Extra(id: id, nom: nom, prixTTC: prixTTC),
      _ => throw Exception("Impossible de créer un Extra à partir de $json"),
    };
  }

  static Extra fromMap(Map<String, dynamic> map) {
    return Extra(
      id: map['id'],
      nom: map['nom'],
      prixTTC: map['prixTTC'],
    );
  }
   @override
     Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nom": nom,
      "prixTTC": prixTTC,
    };
  }

  int getprixTTC() {
    return prixTTC;
  }

   @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final Extra otherExtra = other as Extra;
    return nom == otherExtra.nom && prixTTC == otherExtra.prixTTC;
  }

  @override
  int get hashCode => Object.hash(nom, prixTTC);
  
}