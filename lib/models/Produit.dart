import "Ingredient.dart";
import "Extra.dart";

class Produit {

  int id;
  String nom;
  int prixHt;
  List<Extra> extras;
  List<Ingredient> ingredients;

  Produit(this.id, this.nom, this.prixHt, this.extras, this.ingredients);

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

  List<Extra> getExtras() {
    return this.extras;
  }

  List<Ingredient> getIngredients() {
    return this.ingredients;
  }
  
}