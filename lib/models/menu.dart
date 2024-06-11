import "package:get_storage/get_storage.dart";

import "produit.dart";

class Menu {
  static final GetStorage carte = GetStorage("carte");
  final int id;
  final String nom;
  final int prixHT;
  final List<Produit> produits;

  Menu({
    required this.id,
    required this.nom,
    required this.prixHT, 
    required this.produits,
  });

  factory Menu.fromJson(Map<String, dynamic> json){
    List<Produit> produitsResults = [];
    var produitsFromJson = json['produitSet'] as List;
    produitsFromJson.map((produit) => produitsResults.add(carte.read('produits').firstWhere((element) => element.id == produit['id']) as Produit));

    return switch (json) {
      {
        "id": int id,
        "nom": String nom,
        "prixHT": int prixHT,
        "produitSet": List<dynamic> produits,
      } => 
        Menu(id: id, nom: nom, prixHT: prixHT, produits: produitsResults),
        _ => throw Exception("Impossible de créer un Ingredient à partir de $json"),
    };
  }

  double convertPriceToLong(){
    return prixHT / 100;
  }

  double getTTC(){
    return (prixHT * 1.1) / 100;
  }

  int getId() {
    return id;
  }

  String getNom() {
    return nom;
  }

  int getprixHT() {
    return prixHT;
  }

  List<Produit> getProduits() {
    return produits;
  } 
}