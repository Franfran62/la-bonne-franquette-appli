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
    bool enable = json["enable"] == 1;
    return PaiementTypeCommande(
      id: json['id'],
      name: json['name'],
      isEnable: enable,
    );
  }
}