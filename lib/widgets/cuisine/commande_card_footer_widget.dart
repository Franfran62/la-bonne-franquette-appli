import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommandeCardFooterWidget extends StatelessWidget {
  bool commandePaye;

  CommandeCardFooterWidget({this.commandePaye = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft:  Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          commandePaye ? ElevatedButton( onPressed: () => {}, child: const Text("Envoyer")) : SizedBox(),
          ElevatedButton(onPressed: () => {}, child: Text("Supprimer")),
        ],
      ),
    );
  }
}