import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommandeCardFooterWidget extends StatelessWidget {
  bool commandePaye;
  Function envoieFn;
  Function suppressionFn;

  CommandeCardFooterWidget(
      {this.commandePaye = false,
      required this.envoieFn,
      required this.suppressionFn,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          commandePaye
              ? ElevatedButton(
                  style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(Size(175, 50)),
                      backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).colorScheme.secondary),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                  onPressed: () => envoieFn(),
                  child: const Text("Envoyer"))
              : const SizedBox(
                  width: 175,
                ),
          ElevatedButton(
              style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all(Size(175, 50)),
                  backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.secondary),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
              onPressed: () => suppressionFn(),
              child: Text("Supprimer")),
        ],
      ),
    );
  }
}
