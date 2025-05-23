import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/enums/payment_choice.dart';
import 'package:la_bonne_franquette_front/services/provider/payment_notifier.dart';
import 'package:la_bonne_franquette_front/views/cashier/payment/widgets/type_custom.dart';
import 'package:la_bonne_franquette_front/views/cashier/payment/widgets/type_refund.dart';
import 'package:la_bonne_franquette_front/views/cashier/payment/widgets/type_selected.dart';
import 'package:la_bonne_franquette_front/views/cashier/payment/widgets/type_full.dart';
import 'package:provider/provider.dart';

class ChoicePaymentType extends StatefulWidget {
  const ChoicePaymentType({Key? key}) : super(key: key);

  @override
  _ChoicePaymentTypeState createState() => _ChoicePaymentTypeState();
}

class _ChoicePaymentTypeState extends State<ChoicePaymentType> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentNotifier>(
      builder: (context, paymentNotifier, child) {
        return Column(
          children: [
            paymentNotifier.amontDue > 0
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          label: Text("Montant",
                              style: Theme.of(context).textTheme.bodyMedium),
                          labelPadding: EdgeInsets.all(8.0),
                          selected: paymentNotifier.selectedPayment ==
                              PaymentChoice.custom,
                          onSelected: (selected) => paymentNotifier
                              .selectedPayment = PaymentChoice.custom,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                            label: Text("Sélection",
                                style: Theme.of(context).textTheme.bodyMedium),
                            labelPadding: EdgeInsets.all(8.0),
                            selected: paymentNotifier.selectedPayment ==
                                PaymentChoice.selected,
                            onSelected: (selected) => paymentNotifier
                                .selectedPayment = PaymentChoice.selected),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                            label: Text("Payer le reste",
                                style: Theme.of(context).textTheme.bodyMedium),
                            labelPadding: EdgeInsets.all(8.0),
                            selected: paymentNotifier.selectedPayment ==
                                PaymentChoice.full,
                            onSelected: (selected) => paymentNotifier
                                .selectedPayment = PaymentChoice.full),
                      ),
                    ],
                  )
                : _buildRefundButton(paymentNotifier),
            if (paymentNotifier.amontDue > 0 &&
                paymentNotifier.selectedPayment == PaymentChoice.custom)
              TypeCustom(),
            if (paymentNotifier.amontDue > 0 &&
                paymentNotifier.selectedPayment == PaymentChoice.selected)
              TypeSelected(),
            if (paymentNotifier.amontDue > 0 &&
                paymentNotifier.selectedPayment == PaymentChoice.full)
              TypeFull(),
            if (paymentNotifier.amontDue < 0) TypeRefund(),
          ],
        );
      },
    );
  }

  Widget _buildRefundButton(PaymentNotifier paymentNotifier) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ChoiceChip(
            label: Text("Rembourser",
                style: Theme.of(context).textTheme.bodyMedium),
            labelPadding: EdgeInsets.all(8.0),
            selected: true,
            onSelected: null,
          ),
        ),
      ],
    );
  }
}
