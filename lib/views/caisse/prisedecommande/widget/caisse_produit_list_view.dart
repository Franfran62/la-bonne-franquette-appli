import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/interface/identifiable.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/views/caisse/prisedecommande/widget/element_button.dart';
import '../viewmodel/prisedecommande_view_model.dart';

class CaisseProduitListView extends StatelessWidget {
  CaisseProduitListView({
    super.key,
    required this.produits,
    required this.tailleText,
    required this.onAjout,
  });

  final List<Produit>? produits;
  final TextScaler tailleText;
  final PriseDeCommandeViewModel viewModel = PriseDeCommandeViewModel();
  final VoidCallback onAjout;

  Future<void> handlePress(Produit produit) async {
    await viewModel.ajouterProduitAuPanier(produit);
    onAjout();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GridView(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: produits != null && produits!.isNotEmpty
            ? [
                ...produits!.map((element) => Padding(
                      padding: EdgeInsets.all(2.0),
                      child: ElementButton(
                          element: element.nom,
                          tailleText: tailleText,
                          onPressed: () => handlePress(element)),
                    )),
              ]
            : [],
      ),
    );
  }
}
