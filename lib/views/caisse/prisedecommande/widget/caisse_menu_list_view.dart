import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/menu.dart';
import 'package:la_bonne_franquette_front/models/menuItem.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/views/caisse/prisedecommande/viewmodel/prisedecommande_view_model.dart';
import 'package:la_bonne_franquette_front/views/caisse/prisedecommande/widget/caisse_menu_items_list_view.dart';
import 'package:la_bonne_franquette_front/views/caisse/prisedecommande/widget/element_button.dart';

class CaisseMenuListView extends HookWidget {
  final List<Menu>? menus;
  final double taille;
  final TextScaler tailleText;
  final VoidCallback onAjout;
  final PriseDeCommandeViewModel viewModel = PriseDeCommandeViewModel();

  CaisseMenuListView({
    super.key,
    required this.menus,
    required this.taille,
    required this.tailleText,
    required this.onAjout,
  });

  @override
  Widget build(BuildContext context) {
    final selectedMenu = useState<Menu?>(null);
    final selectedMenuItems = useState<MenuItem?>(null);
    final selectedIndexMenuItems = useState<int>(0);
    final selectedProduitInMenuItems = useState<List<bool>>([]);

    void updateMenuItems(Menu menu) {
      selectedMenu.value = menu;
      selectedMenuItems.value = menu.menuItemSet.first;
      viewModel.initMenuEnCours(nom: menu.nom);
      selectedIndexMenuItems.value = 0;
      selectedProduitInMenuItems.value = [];
    }

    void displayNextMenuItems() {
      selectedIndexMenuItems.value++;
      if (selectedIndexMenuItems.value <
          selectedMenu.value!.menuItemSet.length) {
        selectedMenuItems.value =
            selectedMenu.value?.menuItemSet[selectedIndexMenuItems.value];
      } else if (selectedMenu.value != null) {
        viewModel.ajouterMenuAuPanier();
        selectedMenuItems.value = null;
        selectedMenu.value = null;
        onAjout();
      }
    }

    void hookAdd(Produit? produit) async {
      if (produit != null) {
        await viewModel.ajouterMenuEnCours(produit);
        selectedProduitInMenuItems.value.add(true);
        onAjout();
      }
      displayNextMenuItems();
    }

    void hookNext() {
      selectedProduitInMenuItems.value.add(false);
      displayNextMenuItems();
    }

    void hookBack() {
      selectedIndexMenuItems.value--;
      selectedMenuItems.value =
          selectedMenu.value?.menuItemSet[selectedIndexMenuItems.value];
      if (selectedProduitInMenuItems.value[selectedIndexMenuItems.value] ==
          true) {
        viewModel.retirerMenuEnCours(selectedIndexMenuItems.value);
      }
    }

    return Column(
      children: [
        Container(
          height: taille,
          alignment: Alignment.topLeft,
          child: GridView(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: menus != null && menus!.isNotEmpty
                ? menus!
                    .map((menu) => Padding(
                          padding: EdgeInsets.all(2.0),
                          child: ElementButton(
                            element: menu.nom,
                            tailleText: tailleText,
                            onPressed: () => updateMenuItems(menu),
                            isSelected: selectedMenu.value == menu,
                          ),
                        ))
                    .toList()
                : [CircularProgressIndicator()],
          ),
        ),
        if (selectedMenu.value != null)
          Container(
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                SizedBox(
                  height: taille,
                  child: CaisseMenuItemsListView(
                    menuItem: selectedMenuItems.value,
                    menuItemCount: selectedIndexMenuItems.value,
                    tailleText: tailleText,
                    onProduitPressed: hookAdd,
                    onSkipOptional: hookNext,
                    onReturn: hookBack,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
