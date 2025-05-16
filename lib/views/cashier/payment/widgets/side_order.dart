import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/views/cashier/payment/widgets/choice_delivery_date.dart';
import 'package:provider/provider.dart';
import 'package:la_bonne_franquette_front/views/cashier/payment/payment_viewmodel.dart';
import 'package:la_bonne_franquette_front/views/cashier/payment/widgets/item_line_widget.dart';
import 'package:la_bonne_franquette_front/services/provider/payment_notifier.dart';

class SideOrder extends HookWidget {
  const SideOrder({super.key});

  @override
  Widget build(BuildContext context) {
    PaymentViewModel viewModel = PaymentViewModel();

    return Consumer<PaymentNotifier>(
      builder: (context, paymentNotifier, child) {
        return SizedBox(
          width: MediaQuery.of(context).size.width / 2 - 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(viewModel.title,
                  style: Theme.of(context).textTheme.headlineMedium),
              ChoiceDeliveryDate(),
              Padding(padding: EdgeInsets.symmetric(vertical: 12)),
              Expanded(
                child: paymentNotifier.articles.isNotEmpty
                    ? ListView.builder(
                        itemCount: paymentNotifier.articles.length,
                        itemBuilder: (context, index) {
                          final item = paymentNotifier.articles[index];
                          final selected =
                              paymentNotifier.selected.contains(item);
                          final isPaid = paymentNotifier
                              .checkArticlePaymentPaidIndexed(item, index);
                          return ItemLineWidget(
                            item: item,
                            selected: selected,
                            paid: isPaid,
                          );
                        },
                      )
                    : SizedBox(),
              ),
            ],
          ),
        );
      },
    );
  }
}
