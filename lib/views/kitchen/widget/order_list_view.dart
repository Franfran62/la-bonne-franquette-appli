import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/exceptions/request_exception.dart';
import 'package:la_bonne_franquette_front/services/utils/error_dialog_extension.dart';
import '../../../models/order.dart';
import '../../../services/websocket_service.dart';
import '../kitchen_home_viewmodel.dart';
import 'card_order.dart';

class OrderListView extends StatefulWidget {
  final KitchenHomeViewModel viewModel = KitchenHomeViewModel();

  OrderListView({super.key});

  @override
  _OrderListViewState createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  List<Order> order = [];
  final WebSocketService webSocketService = WebSocketService();
  bool filterPaid = false;

  @override
  void initState() {
    super.initState();
    setupWebSocket();
    load();
  }

  void load() {
    try {
      widget.viewModel.getOrderToCook().then((result) {
        setState(() {
          order = result;
        });
      });
    } on RequestException catch (e) {
      context.showError(e.message, redirect: true, route: "login");
    } catch (e) {
      context.showError(e.toString(), redirect: true, route: "login");
    }
  }

  void pop(num id) async {
    setState(() {
      order.remove(order.firstWhere((item) => item.id == id));
      load();
    });
  }

  void setupWebSocket() async {
    try {
      await webSocketService.setWebSocketServerAdress();
      webSocketService.connect((String message) {
        load();
      });
    } on RequestException catch (e) {
      context.showError(e.message, redirect: true, route: "login");
    } catch (e) {
      context.showError("Une erreur inattendue s'est produite.",
          redirect: true, route: "login");
    }
  }

  void updateFilter() async {
    setState(() {
      filterPaid = !filterPaid;
    });
  }

  List<Order> filterOrder() {
    if (filterPaid) {
      return order.where((c) => c.paid == true).toList();
    } else {
      return order;
    }
  }

  @override
  void dispose() {
    webSocketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: <Widget>[
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(64.0, 0.0, 8.0, 0.0),
              child: Text("Commandes payées uniquement ?"),
            ),
            Switch(value: filterPaid, onChanged: (value) => {updateFilter()})
          ],
        ),
        Expanded(
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filterOrder().length,
              itemBuilder: (context, index) {
                return ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: CardOrder(
                      order: filterOrder()[index],
                      load: load,
                      pop: pop,
                    ));
              }),
        ),
      ],
    ));
  }
}
