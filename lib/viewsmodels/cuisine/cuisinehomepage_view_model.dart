import 'package:la_bonne_franquette_front/models/commande.dart';
import 'package:la_bonne_franquette_front/services/api_service.dart';

class CuisineHomepageViewModel {

  final ApiService apiService = ApiService();

  Future<List<Commande>> getCommandeEnCours() async {
    try {
      final response = await apiService.fetchAll(endpoint: '/commandes/status/en-cours', token: true);
      print(response);
      List<Commande> commandes = List<Commande>.from(response.map((commande) => Commande.fromJson(commande)));
      return commandes;
    } catch (e) {
      throw Exception('Impossible de récupérer les commandes en cours');
    }
  }
}