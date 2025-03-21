import 'package:flutter/material.dart';

class CommandeCardHeaderWidget extends StatelessWidget {
  final int numero;
  final int heure;
  final int minute;
  final bool commandePaye;

  CommandeCardHeaderWidget(
      {required this.numero,
      required this.heure,
      required this.minute,
      required this.commandePaye,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: commandePaye ? Theme.of(context).colorScheme.inversePrimary : Colors.redAccent,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('N°${numero.toString()}',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white)),
          Text('${heure.toString()}:${minute.toString()}',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white)),
          Text('${heure.toString()}:${minute.toString()}',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}
