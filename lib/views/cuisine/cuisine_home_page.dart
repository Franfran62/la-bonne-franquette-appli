import 'dart:async';

import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/views/caisse/caisse_home_page.dart';
import 'package:la_bonne_franquette_front/widgets/cuisine/commande_list_view.dart';
import 'package:la_bonne_franquette_front/widgets/side_menu_widget.dart';

class CuisineHomePage extends StatelessWidget {
  CuisineHomePage({super.key});

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onScaleEnd: (ScaleEndDetails details) {
          // Si le mouvement horizontal est suffisamment important et vers la gauche
          if (details.velocity.pixelsPerSecond.dx < -800) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CaisseHomePage()),
            );
          }
        },
        child: Scaffold(
            key: _scaffoldKey,
            drawer: SideMenuWidget(destination: CaisseHomePage(), context: context, scaffoldKey: _scaffoldKey),
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer()
              ),
              title: const Text('Commandes'),
            ),
            body: CommandeListView()
        )
    );
  }
}