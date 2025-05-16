import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/exceptions/request_exception.dart';
import 'package:la_bonne_franquette_front/services/utils/error_dialog_extension.dart';
import 'package:la_bonne_franquette_front/theme.dart';

class CommandeCardFooterWidget extends StatelessWidget {
  final bool orderPaid;
  final Function sendFn;
  final Function removeFn;

  CommandeCardFooterWidget(
      {required this.orderPaid,
      required this.sendFn,
      required this.removeFn,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          orderPaid
              ? _buildButton(context, true, sendFn)
              : _buildButton(context, false, removeFn),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, bool action, Function onPressed) {
    return ElevatedButton(
      style: action
          ? null
          : CustomTheme.getCancelElevatedButtonTheme(Color(0xFFF8F9FA)).style,
      onPressed: () {
        try {
          onPressed();
        } on RequestException catch (e) {
          context.showError(e.message);
        } catch (e) {
          context.showError("Une erreur inattendue s'est produite.",
              redirect: true, route: "login");
        }
      },
      child: Text(action ? "Envoyer" : "Supprimer"),
    );
  }
}
