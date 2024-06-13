import 'package:la_bonne_franquette_front/models/extra.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';

class Ingredient {
  final int id;
  final String nom;
  final bool aCuire;
  final Extra? extra;
  final List<Produit> produits;

  const Ingredient({
    required this.id,
    required this.nom,
    required this.aCuire,
    required this.extra,
    this.produits = const [],
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

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'id': id,
      'nom': nom,
      'aCuire': aCuire,
    };
    return json;
  }

  @override
  String toString() {
    return 'Ingredient(id: $id, nom: $nom, aCuire: $aCuire, extra: $extra, produits: $produits)';
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
    return extra;
  }

  List<Produit> getProduits() {
    return produits;
  }

  void addProduit(Produit produit) {
    produits.add(produit);
  }

  toJson() {
    return {
      'id': id,
      'nom': nom,
      'aCuire': aCuire,
      'extra': extra,
    };
  }

}
