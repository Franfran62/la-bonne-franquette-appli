import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/views/caisse/caisse_home_page.dart';
import 'package:la_bonne_franquette_front/views/cuisine/widget/commande_list_view.dart';
import 'package:la_bonne_franquette_front/widgets/mainScaffold/main_scaffold.dart';

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
        child: MainScaffold(body: CommandeListView(), destination: "/destinationCommande", title: "Commandes", scaffoldKey: _scaffoldKey)
    );
  }
}