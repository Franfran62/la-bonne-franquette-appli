import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/commande.dart';
import 'package:la_bonne_franquette_front/widgets/cuisine/commande_card_commande_widget.dart';
import 'package:la_bonne_franquette_front/widgets/cuisine/commande_card_header_widget.dart';

import 'commande_card_footer_widget.dart';

class CommandeCard extends StatelessWidget {
  final Commande commande;

  const CommandeCard({super.key, required this.commande});

  @override
Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(40.0),
      child: Card(
        color: Theme.of(context).colorScheme.primary,
        child: Column(

          children: <Widget>[
            CommandeCardHeaderWidget(commande.numero, commande.dateSaisie.hour, commande.dateSaisie.minute),
            CommandeCardCommandeWidget(commande),
            CommandeCardFooterWidget(),


          ],
        ),
        ),
    );
  }
}