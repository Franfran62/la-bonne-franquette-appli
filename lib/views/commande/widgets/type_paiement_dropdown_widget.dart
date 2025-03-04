import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:la_bonne_franquette_front/services/stores/database_service.dart';
import 'package:la_bonne_franquette_front/services/provider/paiement_notifier.dart';

class TypePaiementDropDownWidget extends StatefulWidget {
  @override
  _TypePaiementDropDownWidgetState createState() =>
      _TypePaiementDropDownWidgetState();
}

class _TypePaiementDropDownWidgetState
    extends State<TypePaiementDropDownWidget> {
  String? _selectedPaymentType;
  List<String> _paymentTypes = [];

  @override
  void initState() {
    super.initState();
    loadPaymentTypes();
  }

  Future<void> loadPaymentTypes() async {
    List<String> paymentTypes = await DatabaseService.getPaymentTypes();
    setState(() {
      _paymentTypes = paymentTypes;
      if (_paymentTypes.isNotEmpty) {
        _selectedPaymentType = _paymentTypes.first;
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
          DropdownButton<String>(
              borderRadius: BorderRadius.circular(8.0),
              value: _selectedPaymentType,
              items: _paymentTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(value),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                Provider.of<PaiementNotifier>(context, listen: false)
                    .selectedPaymentType = newValue!;
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
