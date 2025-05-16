import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/exceptions/request_exception.dart';
import 'package:la_bonne_franquette_front/models/order.dart';
import 'package:la_bonne_franquette_front/models/projection/order_list_projection.dart';
import 'package:la_bonne_franquette_front/services/api/api_request.dart';
import 'package:la_bonne_franquette_front/views/cashier/payment/payment_viewmodel.dart';

class OrderListViewModel extends ChangeNotifier {
  OrderListViewModel._internal();

  static final OrderListViewModel _instance = OrderListViewModel._internal();

  factory OrderListViewModel() {
    return _instance;
  }

  List<OrderListProjection> _orderList = [];
  DateTime _date = DateTime.now();
  PaymentViewModel paiementViewModel = PaymentViewModel();

  List<OrderListProjection> getOrderList() {
    return _orderList;
  }

  DateTime getDate() {
    return _date;
  }

  void init() {
    _date = DateTime.now();
  }

  void setDate(DateTime date) async {
    _date = date;
    notifyListeners();
  }

  Future<void> refresh() async {
    try {
      var response = await ApiRequest.get(
          endpoint: "/order/list/${_date.year}-${_date.month}-${_date.day}",
          token: true);
      _orderList = (response as List)
          .map((proj) => OrderListProjection.fromJson(proj))
          .toList();
    } on RequestException {
      rethrow;
    } catch (e) {
      throw Exception("Une erreur inattendue s'est produite.");
    }
  }

  Future<void> go(BuildContext context, int id) async {
    try {
      final order =
          await ApiRequest.get(endpoint: "/order/${id}", token: true);
      paiementViewModel.init(context, Order.fromJson(order));
      context.goNamed("caisse_paiement");
    } on RequestException {
      rethrow;
    } catch (e) {
      throw Exception("Une erreur inattendue s'est produite.");
    }
  }
}
