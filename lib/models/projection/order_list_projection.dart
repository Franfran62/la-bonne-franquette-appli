import 'package:la_bonne_franquette_front/models/enums/order_status.dart';

class OrderListProjection {
  int id;
  int number;
  DateTime creationDate;
  DateTime deliveryDate;
  int totalPrice;
  OrderStatus status;
  bool dineIn;
  bool paid;
  String paymentType;

  OrderListProjection({
    required this.id,
    required this.number,
    required this.creationDate,
    required this.deliveryDate,
    required this.totalPrice,
    required this.status,
    required this.dineIn,
    required this.paid,
    required this.paymentType,
  });

  factory OrderListProjection.fromJson(Map<String, dynamic> json) {
    return OrderListProjection(
      id: json['id'],
      number: json['number'],
      creationDate: DateTime.parse(json['creationDate']),
      deliveryDate: DateTime.parse(json['deliveryDate']),
      totalPrice: json['totalPrice'],
      status: OrderStatus.values.firstWhere((e) => e.name == json['status']),
      dineIn: json['dineIn'],
      paid: json['paid'],
      paymentType: json['paymentType'] ?? "",
    );
  }
}
