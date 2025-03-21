import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/commande.dart';
import 'package:la_bonne_franquette_front/services/api/api_service.dart';
import 'package:la_bonne_franquette_front/views/cuisine/widget/commande_card_commande_widget.dart';

import 'commande_card_footer_widget.dart';
import 'commande_card_header_widget.dart';

class CommandeCard extends StatelessWidget {
  final Commande commande;
  final Function loadCommandes;
  final Function popCommande;

  const CommandeCard({super.key, required this.commande, required this.loadCommandes, required this.popCommande});

  void envoieCommande() {
    ApiService.put(endpoint: '/commandes/${commande.commandeId.toString()}', body: {}, token: true).then((value) {
      popCommande(commande.commandeId);
    });
  }

  void supprimerCommande() {
    ApiService.delete(endpoint: '/commandes/${commande.commandeId.toString()}').then((value) {
      popCommande(commande.commandeId);
    });
  }

  @override
Widget build(BuildContext context) {
    final bool commandePaye = commande.paye!;

    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Card(
        color: commandePaye ? Theme.of(context).colorScheme.inversePrimary : Colors.redAccent,
        child: Column(
          children: <Widget>[
            CommandeCardHeaderWidget(numero: commande.numero!, heure: commande.dateSaisie!.hour, minute: commande.dateSaisie!.minute, commandePaye: commandePaye,),
            Expanded(child: CommandeCardCommandeWidget(commande)),
            CommandeCardFooterWidget(commandePaye: commandePaye,envoieFn: envoieCommande, suppressionFn: supprimerCommande,),
            const SizedBox(height: 25.0,),
          ],
        ),
        ),
    );
  }
}