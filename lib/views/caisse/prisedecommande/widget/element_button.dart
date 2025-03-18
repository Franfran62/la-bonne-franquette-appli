import 'package:flutter/material.dart';

class ElementButton extends StatelessWidget {
  final String element;
  final TextScaler tailleText;
  final void Function() onPressed;
  final bool isSelected;
  final bool isNavigator;

  ElementButton(
      {required this.element,
      required this.tailleText,
      required this.onPressed,
      this.isSelected = false,
      this.isNavigator = false});

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
            : 
            isNavigator 
              ? MaterialStateProperty.all(Theme.of(context).colorScheme.secondary)
              : MaterialStateProperty.all(Theme.of(context).colorScheme.inversePrimary)
      ),
      child: Text(
        style: TextStyle(
          color: isNavigator ? Colors.black : Colors.white,
        ),
        element,
        textAlign: TextAlign.center,
        textScaler: tailleText,
      ),
    );
  }
}
