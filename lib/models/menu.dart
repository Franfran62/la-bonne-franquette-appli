import "produit.dart";

class Menu {
  final int id;
  final String nom;
  final int prixHt;
  final List<Produit> produits;

  Menu(this.id, this.nom, this.prixHt, this.produits);

  double convertPriceToLong(){
    return prixHt / 100;
  }

  double getTTC(){
    return (prixHt * 1.1) / 100;
  }

  int getId() {
    return id;
  }

  String getNom() {
    return nom;
  }

  int getPrixHt() {
    return prixHt;
  }

  List<Produit> getProduits() {
    return produits;
  } 
}