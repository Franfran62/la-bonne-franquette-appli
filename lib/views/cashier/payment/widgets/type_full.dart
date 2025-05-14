import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:la_bonne_franquette_front/services/provider/payment_notifier.dart';

class TypeFull extends StatefulWidget {
  const TypeFull({super.key});

  @override
  _TypeFullState createState() => _TypeFullState();
}

class _TypeFullState extends State<TypeFull> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width / 2;
    return Consumer<PaymentNotifier>(
      builder: (context, paymentNotifier, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 4.0),
              child: Row(
                children: [
                  SizedBox(
                    width: width / 2,
                    child: Text("Montant à payer : ",
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  Text("${paymentNotifier.amontDue / 100} €",
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
            const SizedBox(height: 6),
          ],
        );
      },
    );
  }
}
