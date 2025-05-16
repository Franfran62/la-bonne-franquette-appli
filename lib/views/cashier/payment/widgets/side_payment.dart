import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/exceptions/request_exception.dart';
import 'package:la_bonne_franquette_front/services/provider/payment_notifier.dart';
import 'package:la_bonne_franquette_front/services/utils/error_dialog_extension.dart';
import 'package:la_bonne_franquette_front/theme.dart';
import 'package:la_bonne_franquette_front/views/cashier/payment/payment_viewmodel.dart';
import 'package:la_bonne_franquette_front/views/cashier/payment/widgets/validation_payment.dart';
import 'package:la_bonne_franquette_front/views/cashier/payment/widgets/dropdown_payment_type.dart';
import 'package:la_bonne_franquette_front/views/cashier/payment/widgets/choice_payment_type.dart';
import 'package:provider/provider.dart';

class SidePayment extends HookWidget {
  const SidePayment({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentViewModel viewModel = PaymentViewModel();
    final double width = MediaQuery.of(context).size.width / 2;

    return Consumer<PaymentNotifier>(
      builder: (context, paymentNotifier, child) {
        return SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width / 2,
                      child: Text(
                        "Total :",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    Text(
                      "${paymentNotifier.total / 100} €",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width / 2,
                      child: Text(
                        "Reste à payer :",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    Text(
                      "${paymentNotifier.amontDue / 100} €",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              if (paymentNotifier.amontDue != 0)
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: ChoicePaymentType(),
                ),
              if (paymentNotifier.amontDue != 0)
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: DropDownPaymentType(),
                ),
              if (paymentNotifier.amontDue != 0)
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 12),
                  child: ValidationPayment(
                    paymentChoiceState: paymentNotifier.selectedPayment,
                    amontDue: paymentNotifier.amontDue,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 40.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            try {
                              await viewModel.valid();
                              context.goNamed('caisse');
                            } on ForbiddenException catch (e) {
                              context.showLogoutDialog(e.message);
                            } on ConnectionException catch (e) {
                              context.showLogoutDialog(e.message);
                            } on RequestException catch (e) {
                              context.showError(e.message);
                            } catch (e) {
                              context.showError(e.toString(),
                                  redirect: true, route: "login");
                            }
                          },
                          child: Text('Valider')),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          try {
                            await viewModel.cancel();
                            context.goNamed('caisse');
                          } on ForbiddenException catch (e) {
                            context.showLogoutDialog(e.message);
                          } on ConnectionException catch (e) {
                            context.showLogoutDialog(e.message);
                          } on RequestException catch (e) {
                            context.showError(e.message);
                          } catch (e) {
                            context.showError(e.toString(),
                                redirect: true, route: "login");
                          }
                        },
                        style: CustomTheme.getCancelElevatedButtonTheme(
                                Colors.white)
                            .style,
                        child: Text(
                          'Annuler',
                        )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
