import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/exceptions/request_exception.dart';
import 'package:la_bonne_franquette_front/models/enums/payment_choice.dart';
import 'package:la_bonne_franquette_front/services/utils/error_dialog_extension.dart';
import 'package:la_bonne_franquette_front/theme.dart';
import 'package:la_bonne_franquette_front/views/cashier/payment/payment_viewmodel.dart';

class ValidationPayment extends StatefulWidget {
  final PaymentChoice paymentChoiceState;
  final int amontDue;

  ValidationPayment(
      {Key? key, required this.paymentChoiceState, required this.amontDue})
      : super(key: key);
  @override
  _ValidationPaymentState createState() => _ValidationPaymentState();
}

class _ValidationPaymentState extends State<ValidationPayment> {
  @override
  Widget build(BuildContext context) {
    PaymentViewModel viewModel = PaymentViewModel();
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (widget.paymentChoiceState != PaymentChoice.full &&
              widget.paymentChoiceState != PaymentChoice.refund)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await viewModel.pay();
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
                style: CustomTheme.getSecondaryElevatedButtonTheme().style,
                child:
                    Text("Payer", style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
          if (widget.amontDue < 0 &&
              widget.paymentChoiceState == PaymentChoice.refund)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    viewModel.refund();
                    await viewModel.pay();
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
                style: CustomTheme.getSecondaryElevatedButtonTheme().style,
                child: Text("Rembourser",
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
        ]);
  }
}
