
import "package:collection/collection.dart";
import "package:la_bonne_franquette_front/models/interface/identifiable.dart";
import "package:la_bonne_franquette_front/models/menuItem.dart";
import "produit.dart";

class Menu implements Identifiable {
  @override
  final int id;
  @override
  final String nom;
  final int prixTTC;
  final List<MenuItem> menuItemSet;

  Menu({
    required this.id,
    required this.nom,
    required this.prixTTC,
    required this.menuItemSet,
  });

  static Future<Menu> fromJson(Map<String, dynamic> json) async {
    var items = json['menuItemSet'] as List<dynamic>? ?? [];
    return Menu(
      id: json['id'] as int,
      nom: json['nom'] as String,
      prixTTC: json['prixTTC'] as int,
      menuItemSet: await Future.wait(items.map((item) => MenuItem.fromMenuJson(item))),
    );
  }

  @override
  bool operator == (Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Menu otherMenu = other as Menu;
    return nom == otherMenu.nom &&
        ListEquality().equals(menuItemSet, otherMenu.menuItemSet);
  }

  @override
  int get hashCode => Object.hash(
        nom,
        ListEquality().hash(menuItemSet),
      );
}