import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import '../viewmodel/caisse_view_model.dart';

class CaisseProduitListView extends StatelessWidget {
  CaisseProduitListView({
    super.key,
    required this.produits,
    required this.tailleText,
    required this.onProduitSelected,
  });

  final List<Produit>? produits;
  final TextScaler tailleText;
  final CaisseViewModel viewModel = CaisseViewModel();
  final void Function() onProduitSelected;

  void handlePress (Produit produit) {
    viewModel.ajouterProduitAuPanier(produit);
    onProduitSelected();
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: produits != null && produits!.isNotEmpty
          ? [
              ...produits!.map((element) => Padding(
                    padding: EdgeInsets.all(2.0),
                    child: ElevatedButton(
                      onPressed: () => handlePress(element),
                      child: Text(
                        element.nom,
                        textAlign: TextAlign.center,
                        textScaler: tailleText,
                      ),
                    ),
                  )),
            ]
          : [CircularProgressIndicator()],
    );
  }
}
