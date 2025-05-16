import "package:collection/collection.dart";
import "package:la_bonne_franquette_front/models/interface/identifiable.dart";
import "package:la_bonne_franquette_front/models/menuItem.dart";
import "product.dart";

class Menu implements Identifiable {
  @override
  final int id;
  @override
  final String name;
  final int totalPrice;
  final List<MenuItem> menuItems;

  Menu({
    required this.id,
    required this.name,
    required this.totalPrice,
    required this.menuItems,
  });

  static Future<Menu> fromJson(Map<String, dynamic> json) async {
    var items = json['menuItems'] as List<dynamic>? ?? [];
    return Menu(
      id: json['id'] as int,
      name: json['name'] as String,
      totalPrice: json['totalPrice'] as int,
      menuItems:
          await Future.wait(items.map((item) => MenuItem.fromMenuJson(item))),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Menu otherMenu = other as Menu;
    return name == otherMenu.name &&
        ListEquality().equals(menuItems, otherMenu.menuItems);
  }

  @override
  int get hashCode => Object.hash(
        name,
        ListEquality().hash(menuItems),
      );
}
