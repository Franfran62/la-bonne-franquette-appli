import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/interface/identifiable.dart';
import 'package:la_bonne_franquette_front/models/menuItem.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/views/caisse/prisedecommande/widget/element_button.dart';
import '../viewmodel/prisedecommande_view_model.dart';

class CaisseMenuItemsListView extends StatelessWidget {
  CaisseMenuItemsListView({
    super.key,
    required this.menuItem,
    required this.menuItemCount,
    required this.tailleText,
    required this.onProduitPressed,
    required this.onSkipOptional,
    required this.onReturn,
  });

  final MenuItem? menuItem;
  final int menuItemCount;
  final TextScaler tailleText;
  final PriseDeCommandeViewModel viewModel = PriseDeCommandeViewModel();
  final Function(Produit) onProduitPressed;
  final Function() onSkipOptional;
  final Function() onReturn;

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: menuItem != null && menuItem!.produitSet.isNotEmpty
          ? [
              if (menuItemCount > 0)
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: ElementButton(
                    element: "Précédent",
                    tailleText: tailleText,
                    onPressed: onReturn,
                    isNavigator: true,
                  ),
                ),
              if (menuItem!.optional)
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: ElementButton(
                    element: "Suivant",
                    tailleText: tailleText,
                    onPressed: onSkipOptional,
                    isNavigator: true,
                  ),
                ),
              ...menuItem!.produitSet.map((produit) => Padding(
                    padding: EdgeInsets.all(2.0),
                    child: ElementButton(
                        element: produit.nom,
                        tailleText: tailleText,
                        onPressed: () => onProduitPressed(produit)),
                  )),
            ]
          : [],
    );
  }
}
