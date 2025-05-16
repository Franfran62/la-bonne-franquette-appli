import 'package:la_bonne_franquette_front/exceptions/request_exception.dart';
import 'package:la_bonne_franquette_front/models/order.dart';
import 'package:la_bonne_franquette_front/services/api/api_request.dart';

class KitchenHomeViewModel {
  static final KitchenHomeViewModel _singleton =
      KitchenHomeViewModel._internal();

  factory KitchenHomeViewModel() {
    return _singleton;
  }

  KitchenHomeViewModel._internal();

  Future<List<Order>> getOrderToCook() async {
    try {
      final response = await ApiRequest.fetchAll(
          endpoint: '/order/status/en-cours', token: true);
      List<Order> orders =
          List<Order>.from(response.map((order) => Order.fromJson(order)));
      return orders;
    } on RequestException {
      rethrow;
    } catch (e) {
      throw Exception("Impossible de récupérer les order en cours");
    }
  }
}
