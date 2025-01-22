import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/interface/identifiable.dart';
import 'package:la_bonne_franquette_front/models/menuItem.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/views/caisse/widget/element_button.dart';
import '../viewmodel/caisse_view_model.dart';

class CaisseMenuItemsListView extends StatelessWidget {
  CaisseMenuItemsListView({
    super.key,
    required this.menuItem,
    required this.tailleText,
    required this.onProduitPressed, 
  });

  final MenuItem? menuItem;
  final TextScaler tailleText;
  final CaisseViewModel viewModel = CaisseViewModel();
  final Function(Produit) onProduitPressed;

  void handlePress(Produit produit) {
   //TODO: viewModel.ajouterProduitAuPanier(produit);
    onProduitPressed(produit); 
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GridView(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: menuItem != null && menuItem!.produitSet.isNotEmpty
            ? [
                ...menuItem!.produitSet.map((produit) => Padding(
                      padding: EdgeInsets.all(2.0),
                      child: ElementButton(
                          element: produit,
                          tailleText: tailleText,
                          onPressed: () => handlePress(produit)),
                    )),
              ]
            : [],
      ),
    );
  }
}