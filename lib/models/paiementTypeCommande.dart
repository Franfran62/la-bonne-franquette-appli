class PaiementTypeCommande {

  final int id;
  final String name;
  final bool isEnable;

  PaiementTypeCommande({
    required this.id,
    required this.name,
    required this.isEnable,
  });

  static PaiementTypeCommande fromJson(Map<String, dynamic> json) {
    bool enable = json["isEnable"] == 1;
    return PaiementTypeCommande(
      id: json['id'],
      name: json['name'],
      isEnable: enable,
    );
  }

  static PaiementTypeCommande fromMap(Map<String, dynamic> map) {
    bool isEnable = map['isEnable'] == 1;
    return PaiementTypeCommande(
      id: map['id'],
      name: map['name'],
      isEnable: isEnable,
    );
  }

  @override
  String toString() {
    return 'PaiementTypeCommande{id: $id, name: $name, isEnable: $isEnable}';
  }
}