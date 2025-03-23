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
              Text('${heure.toString()}h${minute.toString()}',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ),
            ],
          ),
    );
  }
}
