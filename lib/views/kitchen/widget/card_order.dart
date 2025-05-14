import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/order.dart';
import 'package:la_bonne_franquette_front/models/enums/order_status.dart';
import 'package:la_bonne_franquette_front/services/api/api_request.dart';
import 'package:la_bonne_franquette_front/views/kitchen/widget/card_body.dart';

import 'card_footer.dart';
import 'card_header.dart';

class CardOrder extends StatelessWidget {
  final Order order;
  final Function load;
  final Function pop;

  const CardOrder(
      {super.key, required this.order, required this.load, required this.pop});

  void send() {
    ApiRequest.put(
            endpoint: '/order/${order.id.toString()}', body: {}, token: true)
        .then((value) {
      pop(order.id);
    });
  }

  void remove() {
    ApiRequest.patch(
            endpoint: '/order/${order.id.toString()}',
            body: {
              "status": OrderStatus.ANNULEE.name,
            },
            token: true)
        .then((value) {
      pop(order.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool orderPaid = order.paid!;

    return Container(
      margin: const EdgeInsets.only(
          left: 12.0, right: 12.0, top: 12.0, bottom: 50.0),
      child: Card(
        color: Color(0xFFF8F9FA),
        child: Column(
          children: <Widget>[
            CardHeader(
                number: order.number!,
                date: order.creationDate!,
                orderPaid: orderPaid),
            Expanded(child: CardBody(order)),
            CommandeCardFooterWidget(
              orderPaid: orderPaid,
              sendFn: send,
              removeFn: remove,
            ),
          ],
        ),
      ),
    );
  }
}
