import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/categorie.dart';
import 'package:la_bonne_franquette_front/models/extra.dart';
import 'package:la_bonne_franquette_front/models/menu.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/views/caisse/prisecommande/viewmodel/caisse_view_model.dart';
import 'package:la_bonne_franquette_front/views/caisse/prisecommande/widget/caisse_categorie_list_view.dart';
import 'package:la_bonne_franquette_front/views/caisse/prisecommande/widget/caisse_menu_list_view.dart';
import 'package:la_bonne_franquette_front/views/caisse/panier/viewmodel/panier_view_model.dart';
import 'package:la_bonne_franquette_front/widgets/mainScaffold/main_scaffold.dart';

import 'panier/widget/panier_widget.dart';

class CaisseHomePage extends StatefulWidget {
  const CaisseHomePage({super.key});

  @override
  _CaisseHomePageState createState() => _CaisseHomePageState();
}

class _CaisseHomePageState extends State<CaisseHomePage> {
  CaisseViewModel caisseViewModel = CaisseViewModel();
  PanierViewModel panierViewModel = PanierViewModel();
  bool showMenu = false;
  List<Produit>? produits;
  List<Menu>? menus;
  List<Extra>? extras;
  List<Categorie>? categories;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    loadCarte();
  }

  void loadCarte() async {
    produits = await caisseViewModel.getProduits();
    menus = await caisseViewModel.getMenus();
    extras = await caisseViewModel.getExtras();
    categories = await caisseViewModel.getCategorie();
    setState(() {});
  }

  void updateMenuChoice() {
    showMenu = !showMenu;
    setState(() {});
  }

  void updateModificationChoice() {
    caisseViewModel.updateShowModification();
    setState(() {});
  }

  void updateDestinationChoice() {
    panierViewModel.updateSurplace();
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
                Row(
                  children: [
                    ChoiceChip(
                      label: Text("A l'unité", style: TextStyle(fontSize: 18)),
                      labelPadding: EdgeInsets.all(choiceLabelPadding),
                      selected: !showMenu,
                      onSelected: (selected) => setState(updateMenuChoice),
                    ),
                    SizedBox(width: 8.0),
                    ChoiceChip(
                      label: Text("Menu", style: TextStyle(fontSize: 18)),
                      labelPadding: EdgeInsets.all(choiceLabelPadding),
                      selected: showMenu,
                      onSelected: (selected) => setState(updateMenuChoice),
                    ),
                    Spacer(),
                    ChoiceChip(
                      label: Text(
                          panierViewModel.getSurPlace()
                              ? "Sur place"
                              : "À emporter",
                          style: TextStyle(fontSize: 18)),
                      labelPadding: EdgeInsets.all(choiceLabelPadding),
                      selected: panierViewModel.getSurPlace(),
                      onSelected: (selected) =>
                          setState(updateDestinationChoice),
                    ),
                    SizedBox(width: 8.0),
                    ChoiceChip(
                      label:
                          Text("Modifications", style: TextStyle(fontSize: 18)),
                      labelPadding: EdgeInsets.all(choiceLabelPadding),
                      selected: CaisseViewModel().showModification,
                      onSelected: (selected) =>
                          setState(updateModificationChoice),
                    ),
                    SizedBox(width: 100.0),
                  ],
                ),
                showMenu
                  ? CaisseMenuListView(
                      menus: menus,
                      taille: (defaultHeight - 100) / 3,
                      tailleText: defaultTailleText,
                      onAjout: () => setState(() {}),
                    )
                  : CaisseCategorieListView(
                      categories: categories,
                      taille: (defaultHeight - 100) / 3,
                      tailleText: defaultTailleText,
                      onAjout: () => setState(() {}),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
