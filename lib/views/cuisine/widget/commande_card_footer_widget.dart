import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/theme.dart';

class CommandeCardFooterWidget extends StatelessWidget {
  final bool commandePaye;
  final Function envoieFn;
  final Function suppressionFn;

  CommandeCardFooterWidget(
      {required this.commandePaye,
      required this.envoieFn,
      required this.suppressionFn,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          commandePaye
              ? _buildButton(context, true, envoieFn)
              : _buildButton(context, false, suppressionFn),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, bool action, Function onPressed) {
    return ElevatedButton(
      style: action ? null : CustomTheme.getCancelElevatedButtonTheme(Color(0xFFF8F9FA)).style,
      onPressed: () => onPressed(),
      child: Text(action ? "Envoyer" : "Supprimer"),
    );
  }
}
