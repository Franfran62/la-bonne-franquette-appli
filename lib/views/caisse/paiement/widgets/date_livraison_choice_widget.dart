import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/views/caisse/paiement/viewmodel/paiement_view_model.dart';

class DateLivraisonChoiceWidget extends StatefulWidget {
  const DateLivraisonChoiceWidget({super.key});

  @override
  State<DateLivraisonChoiceWidget> createState() => _DateLivraisonChoiceWidgetState();
}

class _DateLivraisonChoiceWidgetState extends State<DateLivraisonChoiceWidget> {
  final PaiementViewModel viewModel = PaiementViewModel();
  DateTime? _dateLivraison;

@override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final commande = viewModel.commande;
    if (commande != null && commande.dateLivraison != null) {
      setState(() {
        _dateLivraison = commande.dateLivraison!;
      });
    }
  });
}


  Future<void> _showTimePicker() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateLivraison!),
    );

    if (time != null) {
      DateTime newDate = DateTime(viewModel.commande!.dateLivraison!.year, viewModel.commande!.dateLivraison!.month, viewModel.commande!.dateLivraison!.day, time.hour, time.minute);

      if (newDate.isBefore(viewModel.commande!.dateLivraison!)) {
        newDate = newDate.add(const Duration(days: 1));
      }

      setState(() {
        _dateLivraison = newDate;
      });

      viewModel.commande!.dateLivraison = _dateLivraison;
      viewModel.updateDateLivraison();
    }
  }

  @override
  Widget build(BuildContext context) {

    if (_dateLivraison == null) {
      return const CircularProgressIndicator();
    }

    final hour = _dateLivraison!.hour.toString().padLeft(2, '0');
    final minute = _dateLivraison!.minute.toString().padLeft(2, '0');
    final day = viewModel.commande!.dateLivraison!.day.toString();
    final month = viewModel.commande!.dateLivraison!.month.toString();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Pour : ", style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(width: 10),
        TextButton(
          onPressed: _showTimePicker,
          child: Text(
            "${hour}h${minute} ($day/$month)",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
