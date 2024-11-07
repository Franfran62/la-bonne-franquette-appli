import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import '../viewmodel/caisse_view_model.dart';

class CaisseProduitListView extends StatelessWidget {
  CaisseProduitListView({
    super.key,
    required this.list,
  });

  final List<Produit>? list;
  final CaisseViewModel viewModel = CaisseViewModel();

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: [
        ...list!
          .map((element) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: ElevatedButton(
                    onPressed: () => {
            viewModel.ajouterProduitAuPanier(element)
                    },
                    child: Text(element.nom),
                  ),
          )),
      ],
    );
  }
}