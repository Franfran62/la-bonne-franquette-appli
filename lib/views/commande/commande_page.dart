import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/views/commande/viewmodel/commande_view_model.dart';
import 'package:la_bonne_franquette_front/widgets/mainScaffold/main_scaffold.dart';

class CommandePage extends StatefulWidget {
  const CommandePage({super.key});

  @override
  _CommandePageState createState() => _CommandePageState();
}

class _CommandePageState extends State<CommandePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  CommandeViewModel viewModel = CommandeViewModel();

  @override
  Widget build(BuildContext context) {

    return MainScaffold(
      destination: "/cuisine",
      title: "Commande",
      scaffoldKey: _scaffoldKey,
      body: Column(
        children: []
      )
    );
  }
}