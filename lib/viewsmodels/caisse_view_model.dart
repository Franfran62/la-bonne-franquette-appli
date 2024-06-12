import 'package:get_storage/get_storage.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';

class CaisseViewModel {
    final GetStorage carte = GetStorage('carte');
    late List<Produit> produits;

    CaisseViewModel() {
      produits = carte.read('produits') ?? [];
    }
  
  
}