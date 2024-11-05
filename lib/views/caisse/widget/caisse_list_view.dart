import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../viewmodel/caisse_view_model.dart';

class CaisseProduitListView extends StatelessWidget {
  const CaisseProduitListView({
    super.key,
    required this.list,
    required this.viewModel,
  });

  final List? list;
  final CaisseViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ...list!
          .map((element) => ListTile(
        onTap: () => {
          viewModel.ajouterProduitAuPanier(element)
        },
        title: Text(element.nom),
        leading: Text(
            "${(element.prixHt * 1.1 / 100).toStringAsFixed(2)} €"),
      )),
      ],
    );
  }
}