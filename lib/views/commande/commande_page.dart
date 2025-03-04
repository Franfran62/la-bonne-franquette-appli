import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/views/commande/widgets/commande_side_widget.dart';
import 'package:la_bonne_franquette_front/views/commande/widgets/paiement_side_widget.dart';
import 'package:la_bonne_franquette_front/widgets/mainScaffold/main_scaffold.dart';

class CommandePage extends StatefulWidget {
  const CommandePage({super.key});

  @override
  _CommandePageState createState() => _CommandePageState();
}

class _CommandePageState extends State<CommandePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      destination: "/cuisine",
      scaffoldKey: _scaffoldKey,
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: CommandeSideWidget(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              children: [
                PaiementSideWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
