import 'package:la_bonne_franquette_front/services/api/api_service.dart';

class CommandeViewModel {

  static final CommandeViewModel _singleton = CommandeViewModel._internal();
  static Map commandeBody = {};

  factory CommandeViewModel() {
    return _singleton;
  }
  CommandeViewModel._internal();

  Future<bool> sendOrder() async {
    try {
      if (commandeBody.isEmpty && (commandeBody['articles'].isEmpty || commandeBody['menus'].isEmpty)) {
        throw Exception("Le panier est vide.");
      }
      await ApiService.post(endpoint: '/commandes', body: commandeBody, token: true);
    } on Exception {
      rethrow;
    }
    commandeBody = {};   
    return true;
  }
}