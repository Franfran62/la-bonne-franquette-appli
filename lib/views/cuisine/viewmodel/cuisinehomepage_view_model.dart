import 'package:la_bonne_franquette_front/models/commande.dart';
import 'package:la_bonne_franquette_front/services/api/api_service.dart';

class CuisineHomepageViewModel {
  static final CuisineHomepageViewModel _singleton = CuisineHomepageViewModel._internal();

  factory CuisineHomepageViewModel() {
    return _singleton;
  }

  CuisineHomepageViewModel._internal();

  Future<List<Commande>> getCommandeEnCours() async {
    try {
      final response = await ApiService.fetchAll(endpoint: '/commandes/status/en-cours', token: true);
      List<Commande> commandes = List<Commande>.from(response.map((commande) => Commande.fromJson(commande)));
      return commandes;
    } catch (e) {
      print(e);
      throw Exception("Impossible de récupérer les commandes en cours");
    }
  }
}