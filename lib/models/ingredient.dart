import 'package:la_bonne_franquette_front/models/interface/identifiable.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';

class Ingredient implements Identifiable{

  @override
  final int id;
  final String nom;
  final bool aCuire;
  final List<Produit> produits;

  const Ingredient({
    required this.id,
    required this.nom,
    required this.aCuire,
    this.produits = const [],
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

  @override
  String toString() {
    return 'Ingredient(id: $id, nom: $nom, aCuire: $aCuire, produits: $produits)';
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

  List<Produit> getProduits() {
    return produits;
  }
}
