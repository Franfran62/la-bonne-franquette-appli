import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/enums/PaymentChoice.dart';
import 'package:la_bonne_franquette_front/theme.dart';
import 'package:la_bonne_franquette_front/views/caisse/paiement/viewmodel/paiement_view_model.dart';

class ValidPaimentWidget extends StatefulWidget {
  final PaymentChoice paymentChoiceState;
  final int resteAPayer;

  ValidPaimentWidget(
      {Key? key, required this.paymentChoiceState, required this.resteAPayer})
      : super(key: key);
  @override
  _ValidPaimentWidgetState createState() => _ValidPaimentWidgetState();
}

class _ValidPaimentWidgetState extends State<ValidPaimentWidget> {

  @override
  Widget build(BuildContext context) {
    PaiementViewModel viewModel = PaiementViewModel();
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (widget.paymentChoiceState != PaymentChoice.toutPayer &&
              widget.paymentChoiceState != PaymentChoice.rembourser)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ElevatedButton(
                onPressed: () => viewModel.pay(),
                style: CustomTheme.getSecondaryElevatedButtonTheme().style,
                child:
                    Text("Payer", style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
          if (widget.resteAPayer < 0 &&
              widget.paymentChoiceState == PaymentChoice.rembourser)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ElevatedButton(
                onPressed: () => {viewModel.rembourser(), viewModel.pay()},
                style: CustomTheme.getSecondaryElevatedButtonTheme().style,
                child: Text("Rembourser",
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
        ]);
  }
}
