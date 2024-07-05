import 'package:la_bonne_franquette_front/models/commande.dart';
import 'package:la_bonne_franquette_front/services/api_service.dart';

class CuisineHomepageViewModel {


  Future<List<Commande>> getCommandeEnCours() async {
    try {
      final response = await ApiService.fetchAll(endpoint: '/commandes/status/en-cours', token: true);
      List<Commande> commandes = List<Commande>.from(response.map((commande) => Commande.fromJson(commande)));
      return commandes;
    } catch (e) {
      throw Exception("Impossible de récupérer les commandes en cours");
    }
  }
}