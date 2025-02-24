import 'package:la_bonne_franquette_front/services/api/api_service.dart';
import 'package:la_bonne_franquette_front/services/provider/commande_notifier.dart';
import 'package:flutter/foundation.dart';


class CommandeViewModel extends ChangeNotifier {

  static final CommandeViewModel _singleton = CommandeViewModel._internal();
  int? resteAPayer;
  String? title;
  
  CommandeNotifier commandeNotifier = CommandeNotifier();

  factory CommandeViewModel() {
    return _singleton;
  }
  CommandeViewModel._internal();

  void init() {
   if (commandeNotifier.currentCommande.paiementSet.isNotEmpty) {
    for (var paiement in commandeNotifier.currentCommande.paiementSet) {
      resteAPayer = commandeNotifier.currentCommande.prixHT! - paiement.prixHT;
    }
   } else {
     resteAPayer = commandeNotifier.currentCommande.prixHT;
    }
  title = commandeNotifier.currentCommande.numero != null
      ? "Commande numéro ${commandeNotifier.currentCommande.numero}"
      : "Commande en cours";
  }


  Future<bool> sendOrder() async {
    try {
      if (commandeNotifier.currentCommande.articles.isEmpty && commandeNotifier.currentCommande.menus.isEmpty) {
        throw Exception("Le panier est vide.");
      }
      await ApiService.post(endpoint: '/commandes', body: commandeNotifier.currentCommande.toCreateCommandeJson(), token: true);
    } on Exception {
      rethrow;
    }  
    return true;
  }
}