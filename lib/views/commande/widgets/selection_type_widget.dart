import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:la_bonne_franquette_front/services/provider/paiement_notifier.dart';

class SelectionTypeWidget extends StatefulWidget {
  const SelectionTypeWidget({super.key});

  @override
  _SelectionTypeWidgetState createState() => _SelectionTypeWidgetState();
}

class _SelectionTypeWidgetState extends State<SelectionTypeWidget> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width / 2;
    return Consumer<PaiementNotifier>(
      builder: (context, paiementNotifier, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 4.0),
              child: Row(
                children: [
                  SizedBox(
                    width: width / 2,
                    child: Text("Nombre d'article : ",
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  Text(paiementNotifier.currentSelection.length.toString(),
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 12.0, left: 4.0),
              child: Row(
                children: [
                  SizedBox(
                    width: width / 2,
                    child: Text("Montant sélectionné : ",
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  Text("${paiementNotifier.displayTotalSelection() / 100} €",
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
            const SizedBox(height: 6),
          ],
        );
      },
    );
  }
}
