import 'package:collection/collection.dart';
import 'package:la_bonne_franquette_front/models/product.dart';
import 'package:la_bonne_franquette_front/services/stores/database_request.dart';

class MenuItem {
  final int id;
  final bool optional;
  final int? totalPrice;
  final List<Product> products;

  MenuItem({
    required this.id,
    required this.optional,
    this.totalPrice,
    required this.products,
  });

  static Future<MenuItem> fromMenuJson(Map<String, dynamic> json) async {
    List<int> produitIdList = (json['products'] as List<dynamic>)
        .map((produit) => produit['id'] as int)
        .toList();
    List<Product> products =
        await DatabaseRequest.findAllProductById(produitIdList);
    return MenuItem(
      id: json['id'] as int,
      optional: json['optional'] as bool,
      totalPrice: json['totalPrice'] as int?,
      products: products,
    );
  }

  static MenuItem fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id'],
      optional: map['optional'] == 1,
      totalPrice: map['totalPrice'],
      products: [],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final MenuItem otherMenuItem = other as MenuItem;
    return id == otherMenuItem.id &&
        otherMenuItem.optional == optional &&
        otherMenuItem.totalPrice == totalPrice &&
        ListEquality().equals(products, otherMenuItem.products);
  }

  @override
  int get hashCode => Object.hash(
        id,
        totalPrice,
        optional,
        ListEquality().hash(products),
      );
}
