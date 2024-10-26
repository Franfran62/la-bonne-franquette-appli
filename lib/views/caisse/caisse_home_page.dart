import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/router/routes.dart';
import 'package:la_bonne_franquette_front/views/caisse/widget/panier_widget.dart';
import 'package:la_bonne_franquette_front/views/cuisine/cuisine_home_page.dart';
import 'package:la_bonne_franquette_front/views/panier/panier_page.dart';
import 'package:la_bonne_franquette_front/views/caisse/viewmodel/caisse_view_model.dart';
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      width: constraints.maxWidth / 4, // 1/4 de la largeur de l'écran
                      child: Column(
                        children: [
                          PanierWidget(),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    SingleChildScrollView(
                      child: /*produits!.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: produits?.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return ElevatedButton(
                              onPressed: () {
                                viewModel.ajouterAuPanier(produits![index]);
                              },
                              child: Text(produits![index].nom));
                        })
                    : */CircularProgressIndicator(),
                    ),
                  ],
                ),
              )
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
                  )),
            ],
          )
        ],
      ),
    );
  }
}

/*


          Row(
            children: [
              Column(
                children: <Widget>[
                  (produits != null && produits!.isNotEmpty)
                      ? ListView.builder(
                      itemCount: produits?.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return ElevatedButton(onPressed: () {
                          viewModel.ajouterAuPanier(produits![index]);
                        }, child: Text(produits![index].nom));
                  })


                  ListView(children: <Widget>[
                          for (var p in produits!)
                            ElevatedButton(onPressed: () {
                              viewModel.ajouterAuPanier(p);
                            }, child: Text(p.nom))
                            ListTile(
                              onTap: () {
                                viewModel.ajouterAuPanier(p);
                              },
                              title: Text(p.nom,
                                  style: Theme.of(context).textTheme.bodyMedium),
                              leading: Text(
                                  "${(p.prixHt / 100).toStringAsFixed(2)} €",
                                  style: Theme.of(context).textTheme.bodyMedium),
                            ),
                        ])
                      : const CircularProgressIndicator(),
                ],
              ),
            ],
          ),

 */
