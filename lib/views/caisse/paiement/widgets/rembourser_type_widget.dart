import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:la_bonne_franquette_front/services/provider/paiement_notifier.dart';

class RembourserTypeWidget extends StatefulWidget {
  const RembourserTypeWidget({super.key});

  @override
  _RembourserTypeWidgetState createState() => _RembourserTypeWidgetState();
}

class _RembourserTypeWidgetState extends State<RembourserTypeWidget> {
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
                    child: Text("Montant à rembourser : ",
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  Text("${-paiementNotifier.resteAPayer / 100} €",
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
