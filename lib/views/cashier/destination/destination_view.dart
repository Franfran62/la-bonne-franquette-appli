import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_entry/order_entry_viewmodel.dart';
import 'package:la_bonne_franquette_front/widgets/main_scaffold.dart';

class DestinationView extends StatelessWidget {
  final OrderEntryViewModel viewModel = OrderEntryViewModel();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final double buttonSize = 32.0;

  DestinationView({super.key});

  @override
  Widget build(BuildContext context) {
    void handleChoice(bool dineIn) {
      viewModel.init(dineIn);
      context.pushNamed('caisse_prise_de_commande');
    }

    Widget buildButton(bool dineIn, IconData icon, String text) {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.all(buttonSize * 2),
          child: ElevatedButton(
            onPressed: () => handleChoice(dineIn),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.inversePrimary),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: buttonSize,
                  color: Colors.white,
                ),
                Text(text,
                    style:
                        TextStyle(fontSize: buttonSize, color: Colors.white)),
              ],
            ),
          ),
        ),
      );
    }

    return MainScaffold(
      body: Center(
        child: Row(
          children: [
            buildButton(
              true,
              Icons.table_bar_outlined,
              "Sur place",
            ),
            buildButton(false, Icons.shopping_bag_outlined, "À emporter"),
          ],
        ),
      ),
      destination: "cuisine",
      scaffoldKey: _scaffoldKey,
    );
  }
}
