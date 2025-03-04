import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/enums/PaymentChoice.dart';
import 'package:la_bonne_franquette_front/services/provider/paiement_notifier.dart';
import 'package:la_bonne_franquette_front/views/commande/widgets/montant_type_widget.dart';
import 'package:la_bonne_franquette_front/views/commande/widgets/selection_type_widget.dart';
import 'package:la_bonne_franquette_front/views/commande/widgets/toutpayer_type_widget.dart';
import 'package:provider/provider.dart';

class TypePaiementWidget extends StatefulWidget {
  const TypePaiementWidget({Key? key}) : super(key: key);

  @override
  _TypePaiementWidgetState createState() => _TypePaiementWidgetState();
}

class _TypePaiementWidgetState extends State<TypePaiementWidget> {

  @override
  Widget build(BuildContext context) {
    
    return Consumer<PaiementNotifier>(
      builder: (context, paiementNotifier, child) {
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text("Montant",
                        style: Theme.of(context).textTheme.bodyMedium),
                    labelPadding: EdgeInsets.all(8.0),
                    selected: paiementNotifier.selectedPayment == PaymentChoice.montant,
                    onSelected: (selected) => paiementNotifier.selectedPayment = PaymentChoice.montant,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                      label: Text("Sélection",
                          style: Theme.of(context).textTheme.bodyMedium),
                      labelPadding: EdgeInsets.all(8.0),
                      selected: paiementNotifier.selectedPayment == PaymentChoice.selection,
                      onSelected: (selected) =>
                          paiementNotifier.selectedPayment = PaymentChoice.selection),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text("Payer le reste",
                        style: Theme.of(context).textTheme.bodyMedium),
                    labelPadding: EdgeInsets.all(8.0),
                    selected: paiementNotifier.selectedPayment == PaymentChoice.toutPayer,
                    onSelected: (selected) =>
                        paiementNotifier.selectedPayment = PaymentChoice.toutPayer),
                  ),
              ],
            ),
            if (paiementNotifier.selectedPayment == PaymentChoice.montant)
            MontantTypeWidget(),
            if (paiementNotifier.selectedPayment == PaymentChoice.selection)
            SelectionTypeWidget(),
            if (paiementNotifier.selectedPayment == PaymentChoice.toutPayer)
            ToutPayerTypeWidget(),
          ],
        );
      },
    );
  }
}
