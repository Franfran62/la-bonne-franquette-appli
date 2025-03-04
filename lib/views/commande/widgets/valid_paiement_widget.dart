import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/theme.dart';
import 'package:la_bonne_franquette_front/views/commande/viewmodel/commande_view_model.dart';
import 'ticket_de_caisse_modal.dart';

class ValidPaimentWidget extends StatefulWidget {

  final bool showPayer;

  ValidPaimentWidget({Key? key, required this.showPayer}) : super(key: key);
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
        ChoiceChip(
          label: Text("Envoyer par mail",
              style: Theme.of(context).textTheme.bodyMedium),
          labelPadding: EdgeInsets.all(8.0),
          selected: false,
          onSelected: (selected) => _showModal(context),
        ),
        if (widget.showPayer)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ElevatedButton(
            onPressed: () => viewModel.pay(), 
            style: CustomTheme.getSecondaryElevatedButtonTheme().style,
            child: Text("Payer",
                style: Theme.of(context).textTheme.bodyLarge),
          ),
        ),
    ]);
  }
}
