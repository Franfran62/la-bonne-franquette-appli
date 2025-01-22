
import "package:la_bonne_franquette_front/models/interface/identifiable.dart";
import "package:la_bonne_franquette_front/models/menuItem.dart";
import "produit.dart";

class Menu implements Identifiable {
  @override
  final int id;
  @override
  final String nom;
  final int prixHT;
  final List<MenuItem> menuItemSet;

  Menu({
    required this.id,
    required this.nom,
    required this.prixHT,
    required this.menuItemSet,
  });

  static Future<Menu> fromJson(Map<String, dynamic> json) async {
    var items = json['menuItemSet'] as List<dynamic>? ?? [];
    return Menu(
      id: json['id'] as int,
      nom: json['nom'] as String,
      prixHT: json['prixHT'] as int,
      menuItemSet: await Future.wait(items.map((item) => MenuItem.fromMenuJson(item))),
    );
  }
}