import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/menu.dart';
import 'package:la_bonne_franquette_front/models/menuItem.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/views/caisse/viewmodel/caisse_view_model.dart';
import 'package:la_bonne_franquette_front/views/caisse/widget/caisse_menu_items_list_view.dart';
import 'package:la_bonne_franquette_front/views/caisse/widget/element_button.dart';

class CaisseMenuListView extends HookWidget {

  final List<Menu>? menus;
  final double taille;
  final TextScaler tailleText;

  CaisseMenuListView({
    super.key,
    required this.menus,
    required this.taille,
    required this.tailleText,
  });

  @override
  Widget build(BuildContext context) {

    final CaisseViewModel viewModel = CaisseViewModel();
    final selectedMenu = useState<Menu?>(null);
    final selectedMenuItems = useState<MenuItem?>(null);
    final selectedProduits = useState<List<Produit>>([]);
    final selectedIndexMenuItems = useState<int>(0);

    updateMenuItems(Menu menu) {
      selectedMenu.value = menu;
      selectedMenuItems.value = menu.menuItemSet.first;
      selectedProduits.value = [];
      selectedIndexMenuItems.value = 0;
    }

    displayNextMenuItems() {
      selectedIndexMenuItems.value++;
      if (selectedIndexMenuItems.value <= (selectedMenu.value!.menuItemSet.length - 1)) {
        selectedMenuItems.value = selectedMenu.value?.menuItemSet[selectedIndexMenuItems.value]; 
      } else if (selectedMenu.value != null) {
        viewModel.ajouterMenuAuPanier(selectedMenu.value!, selectedProduits.value);
        selectedMenuItems.value = null;
      }
    }

    hook(Produit? produit) {
      if (produit != null) {
        selectedProduits.value.add(produit);
      }
      displayNextMenuItems();
    }

    return Column(
      children: [
        SizedBox(
          height: taille,
          child: GridView(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: menus != null && menus!.isNotEmpty
                ? [
                    ...menus!.map((menu) => Padding(
                          padding: EdgeInsets.all(2.0),
                          child: ElementButton(
                            element: menu,
                            tailleText: tailleText,
                            onPressed: () => updateMenuItems(menu),
                            isSelected: selectedMenu.value == menu,
                          ),
                        )),
                  ]
                : [CircularProgressIndicator()],
          ),
        ),
        if (selectedMenu.value != null)
          SizedBox(
          height: taille * 2,
          child: CaisseMenuItemsListView(
            menuItem: selectedMenuItems.value, 
            tailleText: tailleText,
            onProduitPressed: hook 
            )
          ),
      ],
    );
  }
}
