import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/services/provider/paiement_notifier.dart';
import 'package:la_bonne_franquette_front/views/caisse/paiement/viewmodel/paiement_view_model.dart';

class MontantTypeWidget extends StatefulWidget {
  @override
  _MontantTypeWidgetState createState() => _MontantTypeWidgetState();
}

class _MontantTypeWidgetState extends State<MontantTypeWidget> {
  final PaiementNotifier paiementNotifier = PaiementNotifier();
  final PaiementViewModel viewModel = PaiementViewModel();

  int decimalMarker = 0;

  void onNumberPressed(int digit) {
    setState(() {
      switch (decimalMarker) {
        case 0:
          viewModel.number = viewModel.number * 10 + digit;
          break;
        case 1:
          viewModel.number = viewModel.number + (digit / 10);
          decimalMarker++;
          break;
        case 2:
          viewModel.number = viewModel.number + (digit / 100);
          decimalMarker++;
          break;
        default:
          break;
      }
      paiementNotifier.currentMontant = (viewModel.number * 100).toInt();
    });
  }

  void onReturnPressed() {
    setState(() {
      viewModel.number = 0;
      paiementNotifier.currentMontant = 0;
      decimalMarker = 0;
    });
  }

  void onCommaPressed() {
    setState(() {
      decimalMarker++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width / 2;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 12.0, left: 4.0),
          child: Row(
            children: [
              SizedBox(
                width: width / 2,
                child: Text("Montant : ",
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              Text("${paiementNotifier.currentMontant / 100} €",
                  style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(6, (index) => _buildButton(index)),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ...List.generate(4, (index) => _buildButton(index + 6)),
              _buildButton(-2), // Virgule
              _buildButton(-1), // Backspace
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(int value) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0, top: 6.0),
      child: GestureDetector(
        onTap: () {
          if (value == -1) {
            onReturnPressed();
          } else if (value == -2) {
            onCommaPressed();
          } else {
            onNumberPressed(value);
          }
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[500]!,
                offset: Offset(3, 3),
                blurRadius: 6,
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(-3, -3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Center(
            child: value == -1
                ? Icon(Icons.backspace, size: 24, color: Colors.black54)
                : value == -2
                    ? Text(",",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87))
                    : Text("$value",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
          ),
        ),
      ),
    );
  }
}
