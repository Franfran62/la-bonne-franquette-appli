import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/models/enums/PaymentChoice.dart';
import 'package:la_bonne_franquette_front/services/provider/paiement_notifier.dart';
import 'package:la_bonne_franquette_front/views/commande/viewmodel/commande_view_model.dart';
import 'package:la_bonne_franquette_front/views/commande/widgets/valid_paiement_widget.dart';
import 'package:la_bonne_franquette_front/views/commande/widgets/type_paiement_dropdown_widget.dart';
import 'package:la_bonne_franquette_front/views/commande/widgets/type_paiement_widget.dart';
import 'package:provider/provider.dart';

class PaiementSideWidget extends HookWidget {

  const PaiementSideWidget({super.key});

  @override
  Widget build(BuildContext context) {

  final CommandeViewModel viewModel = CommandeViewModel();
  final double width = MediaQuery.of(context).size.width / 2;
  const double choiceLabelPadding = 10.0;

    return Consumer<PaiementNotifier>(
      builder: (context, paiementNotifier, child) {
        return SizedBox(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width / 2,
                        child: Text(
                          "Total :",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      Text(
                        "${paiementNotifier.total / 100} €",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width / 2,
                        child: Text(
                          "Reste à payer :",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      Text(
                        "${paiementNotifier.resteAPayer / 100} €",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: TypePaiementWidget(),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: TypePaiementDropDownWidget(),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 12),
                  child: ValidPaimentWidget(
                    showPayer: paiementNotifier.selectedPayment != PaymentChoice.toutPayer
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 40.0),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => viewModel.valid(context),
                        child: Text( 
                          paiementNotifier.selectedPayment == PaymentChoice.toutPayer
                          ? 'Payer et Valider'
                          : 'Valider'
                          )
                      ),
                      // TODO: Le bouton annuler
                    ],
                  ),
                ),
              ],
            ),
          );
      },
    );
  }
}
