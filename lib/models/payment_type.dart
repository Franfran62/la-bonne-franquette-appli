class PaymentType {
  final int id;
  final String name;
  final bool isEnable;

  PaymentType({
    required this.id,
    required this.name,
    required this.isEnable,
  });

  static PaymentType fromJson(Map<String, dynamic> json) {
    bool enable = json["isEnable"] == 1;
    return PaymentType(
      id: json['id'],
      name: json['name'],
      isEnable: enable,
    );
  }

  static PaymentType fromMap(Map<String, dynamic> map) {
    bool isEnable = map['isEnable'] == 1;
    return PaymentType(
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
