import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/enums/PaymentChoice.dart';
import 'package:la_bonne_franquette_front/theme.dart';
import 'package:la_bonne_franquette_front/views/commande/viewmodel/commande_view_model.dart';
import 'ticket_de_caisse_modal.dart';

class ValidPaimentWidget extends StatefulWidget {

  final PaymentChoice paymentChoiceState;
  final int resteAPayer;

  ValidPaimentWidget({Key? key, required this.paymentChoiceState, required this.resteAPayer}) : super(key: key);
  @override
  _ValidPaimentWidgetState createState() => _ValidPaimentWidgetState();
}

class _ValidPaimentWidgetState extends State<ValidPaimentWidget> {

  void _showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TicketDeCaisseModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    CommandeViewModel viewModel = CommandeViewModel();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start, 
      children: [
        // ChoiceChip(
        //   label: Text("Envoyer par mail",
        //       style: Theme.of(context).textTheme.bodyMedium),
        //   labelPadding: EdgeInsets.all(8.0),
        //   selected: false,
        //   onSelected: (selected) => _showModal(context),
        // ),
        if (widget.paymentChoiceState != PaymentChoice.toutPayer && widget.paymentChoiceState != PaymentChoice.rembourser)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ElevatedButton(
            onPressed: () => viewModel.pay(),
            style: CustomTheme.getSecondaryElevatedButtonTheme().style,
            child: Text("Payer",
                style: Theme.of(context).textTheme.bodyLarge),
          ),
        ),
        if (widget.resteAPayer < 0 && widget.paymentChoiceState == PaymentChoice.rembourser)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ElevatedButton(
            onPressed: () => { 
               viewModel.rembourser(),
               viewModel.pay()
            }, 
            style: CustomTheme.getSecondaryElevatedButtonTheme().style,
            child: Text("Rembourser",
                style: Theme.of(context).textTheme.bodyLarge),
          ),
        ),

    ]);
  }
}
