
import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/widgets/mainScaffold/main_scaffold.dart';

class ListeDeCommandePage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ListeDeCommandePage({super.key});

  @override
  Widget build(BuildContext context) {
      return MainScaffold(
        scaffoldKey: _scaffoldKey,
        destination: "cuisine", 
        body: Column()
        );        
  }
}
