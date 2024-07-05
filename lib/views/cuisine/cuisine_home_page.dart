import 'dart:async';

import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/commande.dart';
import 'package:la_bonne_franquette_front/services/websocket_service.dart';
import 'package:la_bonne_franquette_front/views/caisse/caisse_home_page.dart';
import 'package:la_bonne_franquette_front/viewsmodels/cuisine/cuisinehomepage_view_model.dart';
import 'package:la_bonne_franquette_front/widgets/cuisine/commande_card_widget.dart';

class CuisineHomePage extends StatefulWidget {
  @override
  _CuisineHomePageState createState() => _CuisineHomePageState();

  final CuisineHomepageViewModel viewModel = CuisineHomepageViewModel();
}

class _CuisineHomePageState extends State<CuisineHomePage> {

  List<Commande> commandes = [];
  final WebSocketService webSocketService = WebSocketService();

  @override
  void initState() {
    super.initState();
    loadCommandes();
    setupWebSocket();
  }

  void loadCommandes() async {
    try {
      commandes = await widget.viewModel.getCommandeEnCours();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void setupWebSocket() async {
      await webSocketService.setBaseAddressServer();
      webSocketService.connect();
  }

  @override
  void dispose() {
    webSocketService.disconnect();
    super.dispose();
  }

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
        body: Center(
          child: 
            Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: commandes.length,
                    itemBuilder: (context, index) {
                      return ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: CommandeCard(commande: commandes[index])
                      );
                    }
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child:
                ElevatedButton(
                  onPressed: loadCommandes,
                  child: const Text("Charger les commandes en cours"),
                  )
                ),
                ElevatedButton(onPressed: () {
                  Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => CaisseHomePage()), 
                  );
                  }, child: Text('Retour à la caisse')),
                  ],
                )
              ],
            )
          )
        )
      );
 }
}
    