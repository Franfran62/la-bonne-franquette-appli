import 'package:flutter/material.dart';

class CommandeCardHeaderWidget extends StatelessWidget{
  int numero;
  int heure;
  int minute;

  CommandeCardHeaderWidget(this.numero, this.heure, this.minute, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: const BorderRadius.only(
          topLeft:  Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
            'Numero ${numero.toString()}',
            style: Theme.of(context).textTheme.headlineSmall
        ),
        Text(
            '${heure.toString()}:${minute.toString()}',
            style: Theme.of(context).textTheme.headlineSmall
        ),
      ],
    ),);
  }
}