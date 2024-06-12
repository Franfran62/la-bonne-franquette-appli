import 'package:la_bonne_franquette_front/models/extra.dart';
import 'package:la_bonne_franquette_front/models/ingredient.dart';

class Article{
  final String nom;
  int quantite;
  final int prixHT;
  final List<Ingredient> ingredients;
  final List<Extra> extras;

  Article({
    required this.nom,
    required this.quantite,
    required this.prixHT,
    required this.ingredients,
    required this.extras,
  });

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'quantite': quantite,
      'prixHT': prixHT,
      'ingredients': [],
      'extraSet': extras.map((e) => e.toJson()).toList(),
    };
  } 
}