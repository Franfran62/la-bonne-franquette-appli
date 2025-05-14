import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/exceptions/request_exception.dart';
import 'package:la_bonne_franquette_front/services/utils/error_dialog_extension.dart';
import 'package:la_bonne_franquette_front/services/utils/time_formatter.dart';
import 'package:la_bonne_franquette_front/views/cashier/payment/payment_viewmodel.dart';

class ChoiceDeliveryDate extends StatefulWidget {
  const ChoiceDeliveryDate({super.key});

  @override
  State<ChoiceDeliveryDate> createState() => _ChoiceDeliveryDateState();
}

class _ChoiceDeliveryDateState extends State<ChoiceDeliveryDate> {
  final PaymentViewModel viewModel = PaymentViewModel();
  DateTime? _deliveryDate;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final order = viewModel.order;
      if (order != null && order.deliveryDate != null) {
        setState(() {
          _deliveryDate = order.deliveryDate!;
        });
      }
    });
  }

  Future<void> _showTimePicker() async {
    try {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_deliveryDate!),
      );

      if (time != null) {
        DateTime newDate = DateTime(
            viewModel.order!.deliveryDate!.year,
            viewModel.order!.deliveryDate!.month,
            viewModel.order!.deliveryDate!.day,
            time.hour,
            time.minute);

        if (newDate.isBefore(viewModel.order!.deliveryDate!)) {
          newDate = newDate.add(const Duration(days: 1));
        }

        setState(() {
          _deliveryDate = newDate;
        });

        viewModel.order!.deliveryDate = _deliveryDate;
        viewModel.updateDeliveryDate();
      }
    } on ForbiddenException catch (e) {
      context.showLogoutDialog(e.message);
    } on ConnectionException catch (e) {
      context.showLogoutDialog(e.message);
    } on RequestException catch (e) {
      context.showError(e.message);
    } catch (e) {
      context.showError(e.toString(), redirect: true, route: "login");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_deliveryDate == null) {
      return const CircularProgressIndicator();
    }
    final day = viewModel.order!.deliveryDate!.day.toString();
    final month = viewModel.order!.deliveryDate!.month.toString();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Pour : ", style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(width: 10),
        TextButton(
          onPressed: _showTimePicker,
          child: Text(
            "${TimeFormatter.withSeparator(viewModel.order!.deliveryDate!)} ($day/$month)",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
