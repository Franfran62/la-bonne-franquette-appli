import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/views/caisse/widget/panier_widget.dart';
import 'package:la_bonne_franquette_front/views/caisse/viewmodel/caisse_view_model.dart';
import 'package:la_bonne_franquette_front/views/panier/viewmodel/panier_view_model.dart';
import 'package:la_bonne_franquette_front/widgets/mainScaffold/main_scaffold.dart';

class CaisseHomePage extends StatefulWidget {
  const CaisseHomePage({super.key});

  @override
  _CaisseHomePageState createState() => _CaisseHomePageState();
}

class _CaisseHomePageState extends State<CaisseHomePage> {
  CaisseViewModel viewModel = CaisseViewModel();

  List<Produit>? produits;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    loadProduits();
  }

  void loadProduits() async {
    produits = await viewModel.getProduits();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const double defaultHeight = 600;
    const double titleSize = 20;
    return MainScaffold(
      destination: "/cuisine",
      title: "Passer une commande",
      scaffoldKey: _scaffoldKey,
      body: Column(
        children: [
          Row(
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
                          "Votre Commande"
                      ),
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return SizedBox(
                          height: defaultHeight-titleSize,
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
                child: produits != null && produits!.isNotEmpty
                    ? SizedBox(
                        height: defaultHeight,
                        child: ListView(
                          shrinkWrap: true,
                          children: produits!
                              .map((produit) => ListTile(
                                    onTap: () {
                                      viewModel.ajouterAuPanier(produit);
                                    },
                                    title: Text(produit.nom),
                                    leading: Text(
                                        "${(produit.prixHt * 1.1 / 100).toStringAsFixed(2)} €"),
                                  ))
                              .toList(),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    context.go("/panier");
                  },
                  child: const Text('Valider'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}