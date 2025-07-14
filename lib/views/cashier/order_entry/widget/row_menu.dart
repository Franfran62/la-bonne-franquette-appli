import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/menu.dart';
import 'package:la_bonne_franquette_front/models/menuItem.dart';
import 'package:la_bonne_franquette_front/models/product.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_entry/order_entry_viewmodel.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_entry/widget/row_menu_item.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_entry/widget/element_button.dart';

class RowMenu extends HookWidget {
  final List<Menu>? menus;
  final double size;
  final TextScaler fontSize;
  final VoidCallback onPressed;
  final OrderEntryViewModel viewModel = OrderEntryViewModel();

  RowMenu({
    super.key,
    required this.menus,
    required this.size,
    required this.fontSize,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final selectedMenu = useState<Menu?>(null);
    final selectedMenuItems = useState<MenuItem?>(null);
    final selectedIndexMenuItems = useState<int>(0);
    final selectedProductInMenuItems = useState<List<bool>>([]);

    void updateMenuItems(Menu menu) {
      selectedMenu.value = menu;
      selectedMenuItems.value = menu.menuItems.first;
      viewModel.initMenuSelected(name: menu.name, price: menu.totalPrice);
      selectedIndexMenuItems.value = 0;
      selectedProductInMenuItems.value = [];
    }

    void displayNextMenuItems() {
      selectedIndexMenuItems.value++;
      if (selectedIndexMenuItems.value < selectedMenu.value!.menuItems.length) {
        selectedMenuItems.value =
            selectedMenu.value?.menuItems[selectedIndexMenuItems.value];
      } else if (selectedMenu.value != null) {
        viewModel.addMenuToCart();
        selectedMenuItems.value = null;
        selectedMenu.value = null;
        onPressed();
      }
    }

    void hookAdd(Product? produit) async {
      if (produit != null) {
        await viewModel.addToMenuSelected(produit);
        selectedProductInMenuItems.value.add(true);
        onPressed();
      }
      displayNextMenuItems();
    }

    void hookNext() {
      selectedProductInMenuItems.value.add(false);
      displayNextMenuItems();
    }

    void hookBack() {
      selectedIndexMenuItems.value--;
      selectedMenuItems.value =
          selectedMenu.value?.menuItems[selectedIndexMenuItems.value];
      if (selectedProductInMenuItems.value[selectedIndexMenuItems.value] ==
          true) {
        viewModel.removeFromMenuSelected(selectedIndexMenuItems.value);
      }
    }

    return Column(
      children: [
        Container(
          height: size,
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
                            element: menu.name,
                            fontSize: fontSize,
                            onPressed: () => updateMenuItems(menu),
                            selected: selectedMenu.value == menu,
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
                  height: size,
                  child: RowMenuItem(
                    menuItem: selectedMenuItems.value,
                    menuItemCount: selectedIndexMenuItems.value,
                    fontSize: fontSize,
                    onProductPressed: hookAdd,
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
