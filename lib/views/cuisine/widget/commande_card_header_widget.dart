import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/services/utils/time_formatter.dart';

class CommandeCardHeaderWidget extends StatelessWidget {
  final int numero;
  final DateTime date;
  final bool commandePaye;

  CommandeCardHeaderWidget(
      {required this.numero,
      required this.date,
      required this.commandePaye,
      super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                  children: [
                    Text(numero.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ),
                    commandePaye 
                    ? Icon(Icons.attach_money, color: Colors.green,) 
                    : Icon(Icons.money_off, color: Colors.redAccent,)
                  ],
                ),
              Text(TimeFormatter.withSeparator(date),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ),
            ],
          ),
    );
  }
}
