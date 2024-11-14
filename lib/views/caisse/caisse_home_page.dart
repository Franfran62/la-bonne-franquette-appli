import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/models/menu.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/views/caisse/viewmodel/caisse_view_model.dart';
import 'package:la_bonne_franquette_front/views/caisse/widget/caisse_menu_list_view.dart';
import 'package:la_bonne_franquette_front/views/caisse/widget/caisse_produit_list_view.dart';
import 'package:la_bonne_franquette_front/widgets/mainScaffold/main_scaffold.dart';

import '../panier/widget/panier_widget.dart';

class CaisseHomePage extends StatefulWidget {
  const CaisseHomePage({super.key});

  @override
  _CaisseHomePageState createState() => _CaisseHomePageState();
}

class _CaisseHomePageState extends State<CaisseHomePage> {
  CaisseViewModel viewModel = CaisseViewModel();
  bool showMenu = false;

  List<Produit>? produits;
  List<Menu>? menus;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    loadProduits();
    loadMenus();
  }

  void loadProduits() async {
    produits = await viewModel.getProduits();
    setState(() {});
  }

  void loadMenus() async {
    menus = await viewModel.getMenus();
    setState(() {});
  }

  void updateMenuChoice() {
    showMenu = !showMenu;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const double defaultHeight = 600;
    const double titleSize = 20;
    return MainScaffold(
      destination: "/cuisine",
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
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                      ),
                      "Votre Commande"),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      height: defaultHeight - titleSize,
                      width: constraints.maxWidth,
                      child: PanierWidget(height: defaultHeight),
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
                ElevatedButton(onPressed: (updateMenuChoice), child: !showMenu ? Text("Menu") : Text("Produit")),
                SizedBox(
                        height: defaultHeight,
                        child: showMenu ? CaisseMenuListView(menus: menus) : CaisseProduitListView(produits: produits,),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}