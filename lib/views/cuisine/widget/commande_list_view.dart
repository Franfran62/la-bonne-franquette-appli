import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/commande.dart';
import '../../../services/websocket_service.dart';
import '../viewmodel/cuisinehomepage_view_model.dart';
import 'commande_card_widget.dart';

class CommandeListView extends StatefulWidget {

  final CuisineHomepageViewModel viewModel = CuisineHomepageViewModel();

  CommandeListView({super.key});

  @override
  _CommandeListViewState createState() => _CommandeListViewState();
}

class _CommandeListViewState extends State<CommandeListView> {

  List<Commande> commandes = [];
  final WebSocketService webSocketService = WebSocketService();

  @override
  void initState() {
    super.initState();
    setupWebSocket();
    loadCommandes();
  }

  void loadCommandes() {
    try {
      widget.viewModel.getCommandeEnCours().then((result) {
        setState(() {
          commandes = result;
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void popCommande(num id) async {
    setState(() {
      commandes.remove(
          commandes.firstWhere((item) => item.commandeId == id)
      );
      loadCommandes();
    });
  }

  void setupWebSocket() async {
    await webSocketService.setWebSocketServerAdress();
    webSocketService.connect((String message) {
      //faire des trucs ici
      loadCommandes();
    });
  }

  @override
  void dispose() {
    webSocketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: commandes.length,
                itemBuilder: (context, index) {
                  return ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: CommandeCard(commande: commandes[index], loadCommandes: loadCommandes, popCommande: popCommande,)
                  );
                }
            ),
          ),
        ],
      )
    );
  }
}