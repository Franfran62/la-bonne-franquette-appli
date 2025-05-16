import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/views/cashier/home/cashier_home_view.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_entry/order_entry_view.dart';
import 'package:la_bonne_franquette_front/views/kitchen/widget/order_list_view.dart';
import 'package:la_bonne_franquette_front/widgets/main_scaffold.dart';

class KitchenHomeView extends StatelessWidget {
  KitchenHomeView({super.key});

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onScaleEnd: (ScaleEndDetails details) {
          // Si le mouvement horizontal est suffisamment important et vers la gauche
          if (details.velocity.pixelsPerSecond.dx < -800) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CashierHomeView()),
            );
          }
        },
        child: MainScaffold(
            body: OrderListView(),
            destination: "caisse",
            title: "Commandes",
            scaffoldKey: _scaffoldKey));
  }
}
