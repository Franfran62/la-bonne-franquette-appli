import 'package:flutter/material.dart';

class CommandeCardFooterWidget extends StatelessWidget {
  final bool commandePaye;
  final Function envoieFn;
  final Function suppressionFn;

  CommandeCardFooterWidget(
      {this.commandePaye = false,
      required this.envoieFn,
      required this.suppressionFn,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        commandePaye
            ? _buildButton(context, "Envoyer", envoieFn)
            : const SizedBox(width: 175),
        _buildButton(context, "Supprimer", suppressionFn),
      ],
    );
  }

  Widget _buildButton(BuildContext context, String text, Function onPressed) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(const Size(175, 50)),
        backgroundColor: WidgetStateProperty.all(
          Theme.of(context).colorScheme.secondary,
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      onPressed: () => onPressed(),
      child: Text(text),
    );
  }
}
