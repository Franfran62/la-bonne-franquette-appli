import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/widgets/main_scaffold.dart';

class CashierHomeView extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final double buttonSize = 32.0;

  CashierHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    void handleChoice(bool choice) {
      switch (choice) {
        case true:
          context.pushNamed('caisse_destination');
          break;
        case false:
          context.pushNamed('caisse_liste_commande');
          break;
      }
    }

    Widget buildButton(bool choice, IconData icon, String text) {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.all(buttonSize * 2),
          child: ElevatedButton(
            onPressed: () => handleChoice(choice),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: buttonSize,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                Text(text,
                    style: TextStyle(
                        fontSize: buttonSize,
                        color: Theme.of(context).colorScheme.inversePrimary)),
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
              "Prendre une commande",
            ),
            buildButton(
                false, Icons.shopping_bag_outlined, "Voir les commandes"),
          ],
        ),
      ),
      destination: "cuisine",
      scaffoldKey: _scaffoldKey,
    );
  }
}
