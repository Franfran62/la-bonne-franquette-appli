import 'package:la_bonne_franquette_front/models/interface/identifiable.dart';

class Ingredient implements Identifiable {
  @override
  final int id;
  @override
  final String name;

  const Ingredient({
    required this.id,
    required this.name,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "id": int id,
        "name": String name,
      } =>
        Ingredient(id: id, name: name),
      _ =>
        throw Exception("Impossible de créer un Ingredient à partir de $json"),
    };
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'id': id,
      'name': name,
    };
    return json;
  }

  static Ingredient fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['id'],
      name: map['name'],
    );
  }

  @override
  String toString() {
    return 'Ingredient(id: $id, name: $name)';
  }

  int getId() {
    return id;
  }

  String getName() {
    return name;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final Ingredient otherIngredient = other as Ingredient;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => Object.hash(id, name);
}
