import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/models/enums/tables.dart';
import 'package:la_bonne_franquette_front/models/paiementTypeCommande.dart';
import 'package:la_bonne_franquette_front/services/stores/database_service.dart';

class PaiementSideWidget extends StatelessWidget {
  int resteAPayer;
  int selectionne;
  int total;

  PaiementSideWidget({super.key, required this.resteAPayer, required this.selectionne, required this.total});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width / 2;

    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: width / 2,
                  child: Text(
                    "Paiement :",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                // Un jour le Dropdown ici
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: width / 2,
                  child: Text(
                    "Total :",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Text(
                  "${total / 100} €",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     // TODO
                //   },
                //   child: Icon(Icons.email),
                // )
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: width / 2,
                  child: Text(
                    "Total sélectionné :",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Text(
                  "${selectionne / 100} €",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     // TODO
                //   },
                //   child: Icon(Icons.email),
                // )
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: width / 2,
                  child: Text(
                    "Reste à payer :",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Text(
                  "${resteAPayer / 100} €",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     // TODO
                //   },
                //   child: Icon(Icons.email),
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }
}