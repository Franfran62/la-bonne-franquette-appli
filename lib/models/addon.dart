import 'package:la_bonne_franquette_front/models/interface/identifiable.dart';

import 'ingredient.dart';

class Addon implements Identifiable {
  @override
  final int id;
  @override
  final String name;
  final int totalPrice;

  const Addon({
    required this.id,
    required this.name,
    required this.totalPrice,
  });

  factory Addon.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "id": int id,
        "name": String name,
        "totalPrice": int totalPrice,
      } =>
        Addon(id: id, name: name, totalPrice: totalPrice),
      _ => throw Exception("Impossible de créer un Extra à partir de $json"),
    };
  }

  static Addon fromMap(Map<String, dynamic> map) {
    return Addon(
      id: map['id'],
      name: map['name'],
      totalPrice: map['totalPrice'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "totalPrice": totalPrice,
    };
  }

  int getTotalPrice() {
    return totalPrice;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final Addon otherExtra = other as Addon;
    return name == otherExtra.name && totalPrice == otherExtra.totalPrice;
  }

  @override
  int get hashCode => Object.hash(name, totalPrice);
}
