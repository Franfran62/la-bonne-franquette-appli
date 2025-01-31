import 'package:la_bonne_franquette_front/services/api/api_service.dart';
import 'package:la_bonne_franquette_front/services/provider/commande_notifier.dart';

class CommandeViewModel {

  static final CommandeViewModel _singleton = CommandeViewModel._internal();
  CommandeNotifier commandeNotifier = CommandeNotifier();

  factory CommandeViewModel() {
    return _singleton;
  }
  CommandeViewModel._internal();

  Future<bool> sendOrder() async {
    try {
      if (commandeNotifier.currentCommande.articles.isEmpty && commandeNotifier.currentCommande.menus.isEmpty) {
        throw Exception("Le panier est vide.");
      }
      print(commandeNotifier.currentCommande.toCreateCommandeJson());
      await ApiService.post(endpoint: '/commandes', body: commandeNotifier.currentCommande.toCreateCommandeJson(), token: true);
    } on Exception {
      rethrow;
    }  
    return true;
  }
}