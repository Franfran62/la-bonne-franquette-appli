import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:la_bonne_franquette_front/views/caisse/listedecommande/viewmodel/listedecommande_view_model.dart';

class ChoiceDateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final viewModel = Provider.of<ListedeCommandeViewModel>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            "Commande à la date du : ${viewModel.getDate().day}/${viewModel.getDate().month}/${viewModel.getDate().year}",
            style: Theme.of(context).textTheme.headlineMedium),
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: viewModel.getDate(),
              firstDate: DateTime(2025),
              lastDate: DateTime(2101),
            );
            if (picked != null && picked != viewModel.getDate()) {
              viewModel.setDate(picked);
            }
          },
        ),
      ],
    );
  }
}
