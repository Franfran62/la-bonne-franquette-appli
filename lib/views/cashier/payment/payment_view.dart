import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/views/cashier/payment/widgets/side_order.dart';
import 'package:la_bonne_franquette_front/views/cashier/payment/widgets/side_payment.dart';
import 'package:la_bonne_franquette_front/widgets/main_scaffold.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      destination: "cuisine",
      scaffoldKey: _scaffoldKey,
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: SideOrder(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              children: [
                SidePayment(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
