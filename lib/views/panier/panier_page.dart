import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/views/caisse/caisse_home_page.dart';
import 'package:la_bonne_franquette_front/views/cuisine/cuisine_home_page.dart';
import 'package:la_bonne_franquette_front/views/panier/viewmodel/panier_view_model.dart';
import 'package:la_bonne_franquette_front/widgets/mainScaffold/main_scaffold.dart';

class PanierPage extends StatefulWidget {
  const PanierPage({super.key});

  @override
  _PanierPageState createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    PanierViewModel viewModel = PanierViewModel();
    return MainScaffold(
      destination: CuisineHomePage(),
      title: "Panier",
      scaffoldKey: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: viewModel.getArticles().map((a) => ListTile(
                title: Text(a.nom, style: Theme.of(context).textTheme.bodyMedium),
                trailing: Text("${a.getPriceTTC().toStringAsFixed(2)}€", style: Theme.of(context).textTheme.bodyMedium),
                leading: Text(a.quantite.toString(), style: Theme.of(context).textTheme.bodyMedium),
              )).toList(),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            child: Text(
              "Total : ${(viewModel.getTotalPriceTTC()).toStringAsFixed(2)}€",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(context, "Commander", () async {
                try {
                  if (await viewModel.sendOrder()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Commande envoyée avec succès !"))
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => CaisseHomePage()),
                    );
                  }
                } on Exception catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Impossible d'envoyer la commande :\n${e.toString()}"))
                  );
                }
              }),
              _buildButton(context, "Supprimer le panier", () {
                viewModel.clearPanier();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Abandon de la commande."))
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CaisseHomePage()),
                );
              }),
              _buildButton(context, "Retour à la caisse", () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CaisseHomePage()),
                );
              }),
            ],
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}