import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/category.dart';
import 'package:la_bonne_franquette_front/models/menu.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_entry/order_entry_viewmodel.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_entry/widget/row_category.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_entry/widget/row_menu.dart';
import 'package:la_bonne_franquette_front/widgets/main_scaffold.dart';

import 'widget/cart_widget.dart';

class OrderEntryView extends StatefulWidget {
  const OrderEntryView({super.key});

  @override
  _OrderEntryViewState createState() => _OrderEntryViewState();
}

class _OrderEntryViewState extends State<OrderEntryView> {
  OrderEntryViewModel caisseViewModel = OrderEntryViewModel();
  bool showMenu = false;
  List<Menu>? menus;
  List<Category>? categories;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    loadRestaurantMenu();
  }

  void loadRestaurantMenu() async {
    menus = await caisseViewModel.getMenus();
    categories = await caisseViewModel.getCategories();
    setState(() {});
  }

  void updateMenuChoice() {
    showMenu = !showMenu;
    setState(() {});
  }

  void updateModificationChoice() {
    caisseViewModel.updateShow();
    setState(() {});
  }

  void updateDestinationChoice() {
    caisseViewModel.updateDineIn();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const double defaultHeight = 650;
    const TextScaler defaultTailleText = TextScaler.linear(0.7);
    const double titleSize = 20;
    const double choiceLabelPadding = 10.0;

    caisseViewModel.context = context;

    return MainScaffold(
      destination: "cuisine",
      scaffoldKey: _scaffoldKey,
      body: Row(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                      style: Theme.of(context).textTheme.bodyLarge,
                      "Votre Commande"),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      height: defaultHeight - titleSize,
                      width: constraints.maxWidth,
                      child: CartWidget(height: defaultHeight),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Row(
                  children: [
                    ChoiceChip(
                      label: Text("A l'unité",
                          style: Theme.of(context).textTheme.bodyMedium),
                      labelPadding: EdgeInsets.all(choiceLabelPadding),
                      selected: !showMenu,
                      onSelected: (selected) => setState(updateMenuChoice),
                    ),
                    SizedBox(width: 8.0),
                    ChoiceChip(
                      label: Text("Menu",
                          style: Theme.of(context).textTheme.bodyMedium),
                      labelPadding: EdgeInsets.all(choiceLabelPadding),
                      selected: showMenu,
                      onSelected: (selected) => setState(updateMenuChoice),
                    ),
                    Spacer(),
                    ChoiceChip(
                      label: Text(
                          caisseViewModel.getDineIn()
                              ? "Sur place"
                              : "À emporter",
                          style: Theme.of(context).textTheme.bodyMedium),
                      labelPadding: EdgeInsets.all(choiceLabelPadding),
                      selected: caisseViewModel.getDineIn(),
                      onSelected: (selected) =>
                          setState(updateDestinationChoice),
                    ),
                    SizedBox(width: 8.0),
                    ChoiceChip(
                      label: Text("Modifications",
                          style: Theme.of(context).textTheme.bodyMedium),
                      labelPadding: EdgeInsets.all(choiceLabelPadding),
                      selected: OrderEntryViewModel().show,
                      onSelected: (selected) =>
                          setState(updateModificationChoice),
                    ),
                    SizedBox(width: 100.0),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: showMenu
                      ? RowMenu(
                          menus: menus,
                          size: (defaultHeight - 100) / 3,
                          fontSize: defaultTailleText,
                          onPressed: () => setState(() {}),
                        )
                      : RowCategory(
                          categories: categories,
                          size: (defaultHeight - 100) / 3,
                          fontSize: defaultTailleText,
                          onPressed: () => setState(() {}),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
