import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/menuItem.dart';
import 'package:la_bonne_franquette_front/models/product.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_entry/widget/element_button.dart';
import '../order_entry_viewmodel.dart';

class RowMenuItem extends StatelessWidget {
  RowMenuItem({
    super.key,
    required this.menuItem,
    required this.menuItemCount,
    required this.fontSize,
    required this.onProductPressed,
    required this.onSkipOptional,
    required this.onReturn,
  });

  final MenuItem? menuItem;
  final int menuItemCount;
  final TextScaler fontSize;
  final OrderEntryViewModel viewModel = OrderEntryViewModel();
  final Function(Product) onProductPressed;
  final Function() onSkipOptional;
  final Function() onReturn;

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: menuItem != null && menuItem!.products.isNotEmpty
          ? [
              if (menuItemCount > 0)
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: ElementButton(
                    element: "Précédent",
                    fontSize: fontSize,
                    onPressed: onReturn,
                    isNavigator: true,
                  ),
                ),
              if (menuItem!.optional)
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: ElementButton(
                    element: "Suivant",
                    fontSize: fontSize,
                    onPressed: onSkipOptional,
                    isNavigator: true,
                  ),
                ),
              ...menuItem!.products.map((produit) => Padding(
                    padding: EdgeInsets.all(2.0),
                    child: ElementButton(
                        element: produit.name,
                        fontSize: fontSize,
                        onPressed: () => onProductPressed(produit)),
                  )),
            ]
          : [],
    );
  }
}
