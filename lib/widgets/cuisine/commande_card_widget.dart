import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/commande.dart';

class CommandeCard extends StatelessWidget {
  final Commande commande;

  const CommandeCard({super.key, required this.commande});

  @override
Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(40.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 1.0,
            spreadRadius: 1.0,
            offset: const Offset(1.0, 1.0),
          ),
        ],
      ),
      child: Card(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft:  Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Numero ${commande.numero}',
                    style: Theme.of(context).textTheme.headlineSmall
                    ),
                  Text(
                    '${commande.dateSaisie.hour}:${commande.dateSaisie.minute}',
                    style: Theme.of(context).textTheme.headlineSmall
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: commande.articles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(' ${commande.articles[index]}'),
                );
              },
            ),
          ],
        ),
        ),
    );
  }
}