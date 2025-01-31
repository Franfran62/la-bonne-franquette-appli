import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/views/commande/viewmodel/commande_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/widgets/mainScaffold/main_scaffold.dart';
import 'package:la_bonne_franquette_front/widgets/panier/widget/panier_widget.dart';


class CommandePage extends StatefulWidget {
  const CommandePage({super.key});

  @override
  _CommandePageState createState() => _CommandePageState();
}

class _CommandePageState extends State<CommandePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final viewModel = CommandeViewModel();

  @override
  Widget build(BuildContext context) {

    viewModel.init();
    final String title = viewModel.commandeNotifier.currentCommande.numero != null
      ? "Commande numéro ${viewModel.commandeNotifier.currentCommande.numero}"
      : "Commande en cours";

        return MainScaffold(
          destination: "/cuisine",
          scaffoldKey: _scaffoldKey,
          body: Row(
            children: [
              Column(
                children: [
                  Text(
                      title,
                      style: Theme.of(context).textTheme.headlineMedium
                  ),  
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: PanierWidget(height: MediaQuery.of(context).size.height, displaySmall: false),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(10)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Reste à payer : ${viewModel.resteAPayer! / 100} €"),
                  ElevatedButton(
                    onPressed: () async {
                      await viewModel.sendOrder();
                      GoRouter.of(context).go("/destinationCommande");
                    },
                    child: Text('Envoyer'),
                  )
                ]
              ),
            ],
          )
        );
      }
}