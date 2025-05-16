import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:la_bonne_franquette_front/services/stores/database_request.dart';
import 'package:la_bonne_franquette_front/services/provider/payment_notifier.dart';
import 'package:la_bonne_franquette_front/models/payment_type.dart';

class DropDownPaymentType extends StatefulWidget {
  @override
  _DropDownPaymentTypeState createState() => _DropDownPaymentTypeState();
}

class _DropDownPaymentTypeState extends State<DropDownPaymentType> {
  PaymentType? _selectedPaymentType;
  List<PaymentType> _paymentTypes = [];

  @override
  void initState() {
    super.initState();
    loadPaymentTypes();
  }

  Future<void> loadPaymentTypes() async {
    List<PaymentType> paymentTypes =
        await DatabaseRequest.findAllPaymentTypeEnable();
    setState(() {
      _paymentTypes = paymentTypes;
      if (_paymentTypes.isNotEmpty) {
        _selectedPaymentType = _paymentTypes.first;
        Provider.of<PaymentNotifier>(context, listen: false)
            .selectedPaymentType = _selectedPaymentType;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Text(
              "Mode de paiement :",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          DropdownButton<PaymentType>(
            borderRadius: BorderRadius.circular(8.0),
            value: _selectedPaymentType,
            items: _paymentTypes
                .map<DropdownMenuItem<PaymentType>>((PaymentType value) {
              return DropdownMenuItem<PaymentType>(
                value: value,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(value.name),
                ),
              );
            }).toList(),
            onChanged: (PaymentType? newValue) {
              Provider.of<PaymentNotifier>(context, listen: false)
                  .selectedPaymentType = newValue;
              setState(() {
                _selectedPaymentType = newValue;
              });
            },
          ),
        ],
      ),
    );
  }
}
