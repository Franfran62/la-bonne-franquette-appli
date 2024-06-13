import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/viewsmodels/caisse_view_model.dart';

class CaisseHomePage extends StatefulWidget {
  @override
  _CaisseHomePageState createState() => _CaisseHomePageState();  
}

class _CaisseHomePageState extends State<CaisseHomePage> {
  @override
  Widget build(BuildContext context) {
    CaisseViewModel viewModel = CaisseViewModel();
    return Scaffold(
      appBar: AppBar(
        title: Text('Passer une commande'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[ 
                  for(var p in viewModel.produits) ListTile(
                    onTap: () {
                      viewModel.addToCart(p);
                    },
                    title: Text(p.nom, style: Theme.of(context).textTheme.bodyMedium),
                    trailing: Text(p.categories[0].nom, style: Theme.of(context).textTheme.bodyMedium),
                    leading: Text("${p.convertPriceToLong()}€", style: Theme.of(context).textTheme.bodyMedium),
                    ),
                ]
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await viewModel.sendOrder();
              },
              child: const Text('Voirle panier'),
            ),
            const SizedBox(height: 20),
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
    final style = theme.textTheme.displayMedium!.copyWith(color: theme.colorScheme.onPrimary);
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(produit.nom, style: style),
      ),
    );
  }
}