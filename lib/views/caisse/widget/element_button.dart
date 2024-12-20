import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/interface/identifiable.dart';

class ElementButton extends StatelessWidget {
  final Identifiable element;
  final TextScaler tailleText;
  final void Function() onPressed;
  final bool isSelected;

  ElementButton(
      {required this.element,
      required this.tailleText,
      required this.onPressed,
      this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        )),
        backgroundColor: isSelected
            ? MaterialStateProperty.all(Theme.of(context).colorScheme.tertiary)
            : MaterialStateProperty.all(
                Theme.of(context).colorScheme.inversePrimary),
      ),
      child: Text(
        style: TextStyle(
          color: Colors.white,
        ),
        element.nom,
        textAlign: TextAlign.center,
        textScaler: tailleText,
      ),
    );
  }
}
