import "Produit.dart";

class Menu {
  final int id;
  final String nom;
  final int prixHt;
  final List<Produit> produits;

  Menu(this.id, this.nom, this.prixHt, this.produits);

  double convertPriceToLong(){
    return this.prixHt / 100;
  }

  double getTTC(){
    return (this.prixHt * 1.1) / 100;
  }

  int getId() {
    return this.id;
  }

  String getNom() {
    return this.nom;
  }

  int getPrixHt() {
    return this.prixHt;
  }

  List<Produit> getProduits() {
    return this.produits;
  } 
}