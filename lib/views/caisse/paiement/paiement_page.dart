import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/views/caisse/paiement/widgets/commande_side_widget.dart';
import 'package:la_bonne_franquette_front/views/caisse/paiement/widgets/paiement_side_widget.dart';
import 'package:la_bonne_franquette_front/widgets/mainScaffold/main_scaffold.dart';

class PaiementPage extends StatefulWidget {
  const PaiementPage({super.key});

  @override
  _PaiementPageState createState() => _PaiementPageState();
}

class _PaiementPageState extends State<PaiementPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      destination: "cuisine",
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
