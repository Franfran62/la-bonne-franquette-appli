import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/views/caisse/caisse_home_page.dart';

class CuisineHomePage extends StatelessWidget {
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
        appBar: AppBar(
          title: Text('La Bonne Franquette'),
        ),
        body: Center(
          child: Text('Liste des commandes'),
        ),
      ),
    );
  }
}