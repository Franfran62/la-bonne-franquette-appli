
import "package:la_bonne_franquette_front/models/interface/identifiable.dart";
import "produit.dart";

class Menu implements Identifiable {
  
  @override
  final int id;
  @override
  final String nom;
  final int prixHT;
  final List<Produit> produits;

  Menu({
    required this.id,
    required this.nom,
    required this.prixHT, 
    required this.produits,
  });

  factory Menu.fromMap(Map<String, dynamic> json) {
    try {
      var produitList = json['produitSet'] as List<dynamic>;

      List<Produit> produits = produitList
        .map((produitJson) => Produit.fromJson(produitJson))
        .toList();

      return Menu(
            id: json['id'] as int,
            nom: json['nom'] as String,
            prixHT: json['prixHT'] as int,
            produits: produits
          ); 
    } catch (e) {
      throw Exception("Impossible de créer un Menu à partir de $json");
    }
  }

  Map<String, dynamic> register() {
    return {
      "id": id,
      "nom": nom,
      "prixHT": prixHT,
    };
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