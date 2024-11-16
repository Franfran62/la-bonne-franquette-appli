import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import '../viewmodel/caisse_view_model.dart';

class CaisseProduitListView extends StatelessWidget {
  CaisseProduitListView({
    super.key,
    required this.produits,
  });

  final List<Produit>? produits;
  final CaisseViewModel viewModel = CaisseViewModel();

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: produits != null && produits!.isNotEmpty
          ? [
              ...produits!.map((element) => Padding(
                    padding: EdgeInsets.all(2.0),
                    child: ElevatedButton(
                      onPressed: () =>
                          {viewModel.ajouterProduitAuPanier(element)},
                      child: Text(
                        element.nom,
                        textAlign: TextAlign.center,
                        textScaler: TextScaler.linear(1),
                      ),
                    ),
                  )),
            ]
          : [CircularProgressIndicator()],
    );
  }
}
