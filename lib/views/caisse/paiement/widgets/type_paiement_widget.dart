import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/enums/PaymentChoice.dart';
import 'package:la_bonne_franquette_front/services/provider/paiement_notifier.dart';
import 'package:la_bonne_franquette_front/views/caisse/paiement/widgets/montant_type_widget.dart';
import 'package:la_bonne_franquette_front/views/caisse/paiement/widgets/rembourser_type_widget.dart';
import 'package:la_bonne_franquette_front/views/caisse/paiement/widgets/selection_type_widget.dart';
import 'package:la_bonne_franquette_front/views/caisse/paiement/widgets/toutpayer_type_widget.dart';
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
            paiementNotifier.resteAPayer > 0
             ? Row(
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
            )
             : _buildRembourserButton(paiementNotifier),
            if (paiementNotifier.resteAPayer > 0 && paiementNotifier.selectedPayment == PaymentChoice.montant)
            MontantTypeWidget(),
            if (paiementNotifier.resteAPayer > 0 && paiementNotifier.selectedPayment == PaymentChoice.selection)
            SelectionTypeWidget(),
            if (paiementNotifier.resteAPayer > 0 && paiementNotifier.selectedPayment == PaymentChoice.toutPayer)
            ToutPayerTypeWidget(),
            if (paiementNotifier.resteAPayer < 0)
            RembourserTypeWidget(),
          ],
        );
      },
    );
  }

    Widget _buildRembourserButton(PaiementNotifier paiementNotifier) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ChoiceChip(
            label: Text("Rembourser",
                style: Theme.of(context).textTheme.bodyMedium),
            labelPadding: EdgeInsets.all(8.0),
            selected: true,
            onSelected: null,
          ),
        ),
      ],
    );
  }
}
