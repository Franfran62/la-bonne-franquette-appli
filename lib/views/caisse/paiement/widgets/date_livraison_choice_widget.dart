import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/services/provider/commande_notifier.dart';
import 'package:la_bonne_franquette_front/views/caisse/paiement/viewmodel/paiement_view_model.dart';
import 'package:provider/provider.dart';

class DateLivraisonChoiceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PaiementViewModel viewModel = PaiementViewModel();

    return Consumer<CommandeNotifier>(
      builder: (context, commandeNotifier, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Pour : ", style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(width: 10),
            TextButton(
              onPressed: () {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(
                      commandeNotifier.currentCommande.dateLivraison!),
                ).then((time) {
                  if (time != null) {
                    final now = DateTime.now();
                    DateTime date = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      time.hour,
                      time.minute,
                    );
                    if (date.isBefore(now)) {
                      date = date.add(Duration(days: 1));
                    }
                    commandeNotifier.setDateLivraison(date);
                    viewModel.updateDateLivraison();
                  }
                });
              },
              child: Text(
                "${commandeNotifier.currentCommande.dateLivraison!.hour}h${commandeNotifier.currentCommande.dateLivraison!.minute} (${commandeNotifier.currentCommande.dateLivraison!.day}/${commandeNotifier.currentCommande.dateLivraison!.month})",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        );
      },
    );
  }
}
