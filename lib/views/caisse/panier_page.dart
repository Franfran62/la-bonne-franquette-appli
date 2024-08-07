import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/views/caisse/caisse_home_page.dart';
import 'package:la_bonne_franquette_front/views/cuisine/cuisine_home_page.dart';
import 'package:la_bonne_franquette_front/viewsmodels/caisse/panier_view_model.dart';
import 'package:la_bonne_franquette_front/widgets/side_menu_widget.dart';

class PanierPage extends StatefulWidget {
  @override
  _PanierPageState createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    PanierViewModel viewModel = PanierViewModel();
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenuWidget(destination: CuisineHomePage(), context: context, scaffoldKey: _scaffoldKey,),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer()
          ),
        title: Text('Panier'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(children: <Widget>[
                for (var a in viewModel.getArticles())
                  ListTile(
                    title: Text(a.nom,
                        style: Theme.of(context).textTheme.bodyMedium),
                    trailing: Text("${a.getPriceTTC().toStringAsFixed(2)}€",
                        style: Theme.of(context).textTheme.bodyMedium),
                    leading: Text(a.quantite.toString(),
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
              ]),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              child: Text("Total : ${(viewModel.getTotalPriceTTC()).toStringAsFixed(2)}€",
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          if (await viewModel.sendOrder()) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar( content: Text("Commande envoyée avec succès !")));
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                            builder: (context) => CaisseHomePage()),
                      );
                          }
                        } on Exception catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Impossible d'envoyer la commande :\n${e.toString()}")));
                        }
                      },
                      child: const Text('Commander'),
                    )),
                Container(
                  margin: const EdgeInsets.all(5),
                  child: ElevatedButton(
                      onPressed: () {
                        viewModel.clearPanier();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar( content: Text("Abandon de la commande.")));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CaisseHomePage()),
                        );
                        },
                      child: const Text('Supprimer le panier')),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CaisseHomePage()),
                        );
                      },
                      child: const Text('Retour à la caisse')),
                ),
              ],
            ),
            const SizedBox(height: 5,),
          ],
        ),
      ),
    );
  }
}