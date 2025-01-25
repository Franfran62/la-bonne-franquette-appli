
class CommandeViewModel {

  static final CommandeViewModel _singleton = CommandeViewModel._internal();

  factory CommandeViewModel() {
    return _singleton;
  }

  CommandeViewModel._internal();


  //   Future<bool> sendOrder() async {
  //   if (articles.isEmpty && menus.isEmpty) {
  //     throw Exception("Le panier est vide.");
  //   }

  //   Map commandeBody = {
  //     "surPlace": surPlace,
  //     "menus": menus.map((menu) => menu.toJson()).toList(),
  //     "paiementSet": [],
  //     "status": "EN_COURS",
  //     "articles": articles.map((article) => article.toJson()).toList(),
  //     "prixHT": prixTotal * 100,
  //   };
  //   try {
  //     await ApiService.post(
  //         endpoint: '/commandes', body: commandeBody, token: true);
  //   } on Exception {
  //     rethrow;
  //   }
  //   clearPanier();
  //   return true;
  // }
}