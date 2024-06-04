import "ingredient.dart";
import "extra.dart";

class Produit {

  int id;
  String nom;
  int prixHt;
  List<Extra> extras;
  List<Ingredient> ingredients;

  Produit(this.id, this.nom, this.prixHt, this.extras, this.ingredients);

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

  List<Extra> getExtras() {
    return extras;
  }

  List<Ingredient> getIngredients() {
    return ingredients;
  }
  
}