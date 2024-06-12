import 'package:get_storage/get_storage.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';

class CaisseViewModel {
    final GetStorage carte = GetStorage('carte');
    late List<Produit> produits;

    CaisseViewModel() {
      print("--------------${carte.getKeys()}");
      print(carte.read('produits'));
      produits = carte.read('produits') ?? [];
    }
  
  
}