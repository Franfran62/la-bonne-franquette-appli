import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/views/panier/viewmodel/panier_view_model.dart';
import 'package:la_bonne_franquette_front/widgets/mainScaffold/main_scaffold.dart';

class DestinationPage extends StatelessWidget {
  final PanierViewModel viewModel = PanierViewModel();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final double tailleContenu = 32.0;

  DestinationPage({super.key});

  @override
  Widget build(BuildContext context) {
    void handleChoice(bool surPlace) {
      viewModel.setSurPlace(surPlace);
      context.go('/caisse');
    }

    Widget buildButton(bool surPlace, IconData icon, String text) {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.all(tailleContenu * 2),
          child: ElevatedButton(
            onPressed: () => handleChoice(surPlace),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: tailleContenu),
                Text(text, style: TextStyle(fontSize: tailleContenu)),
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
            buildButton(true, Icons.table_bar_outlined, "Sur place"),
            buildButton(false, Icons.shopping_bag_outlined, "À emporter"),
          ],
        ),
      ),
      destination: "/cuisine",
      scaffoldKey: _scaffoldKey,
    );
  }
}