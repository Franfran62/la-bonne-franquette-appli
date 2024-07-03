import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/views/cuisine/cuisine_home_page.dart';
import 'package:la_bonne_franquette_front/views/panier/panier_page.dart';
import 'package:la_bonne_franquette_front/viewsmodels/caisse/caisse_view_model.dart';

class CaisseHomePage extends StatefulWidget {
  @override
  _CaisseHomePageState createState() => _CaisseHomePageState();
}

class _CaisseHomePageState extends State<CaisseHomePage> {

    CaisseViewModel viewModel = CaisseViewModel();
    List<Produit>? produits;
    @override
    void initState() {
      super.initState();
      loadProduits();
    }

    void loadProduits() async {
      produits = await viewModel.getProduits();
      print(produits);
      setState(() {}); 
    }
    
  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passer une commande'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ( produits != null && produits!.isNotEmpty ) 
              ? ListView(children: <Widget>[
                for (var p in produits!)
                  ListTile(
                    onTap: () {
                      viewModel.ajouterAuPanier(p);
                    },
                    title: Text(p.nom,
                        style: Theme.of(context).textTheme.bodyMedium),
                    leading: Text("${(p.prixHt / 100).toStringAsFixed(2)} €",
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ])
              : const CircularProgressIndicator(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PanierPage()),
                        );
                      },
                      child: const Text('Voir le panier'),
                    )),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CuisineHomePage()),
                      );
                    },
                    child: Text('Retour à la cuisine')),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ProduitCard extends StatelessWidget {
  const ProduitCard({
    super.key,
    required this.produit,
  });

  final Produit produit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.onPrimary);
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(produit.nom, style: style),
      ),
    );
  }
}
