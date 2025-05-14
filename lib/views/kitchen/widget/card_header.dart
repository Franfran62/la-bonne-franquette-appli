import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/services/utils/time_formatter.dart';

class CardHeader extends StatelessWidget {
  final int number;
  final DateTime date;
  final bool orderPaid;

  CardHeader(
      {required this.number,
      required this.date,
      required this.orderPaid,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              Text(number.toString(),
                  style: Theme.of(context).textTheme.headlineSmall),
              orderPaid
                  ? Icon(
                      Icons.attach_money,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.money_off,
                      color: Colors.redAccent,
                    )
            ],
          ),
          Text(TimeFormatter.withSeparator(date),
              style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    );
  }
}
