import 'dart:convert';

import 'package:flutter/material.dart';

class SideMenuWidget extends StatelessWidget{

  final StatefulWidget destination;
  final BuildContext context;

  SideMenuWidget({super.key, required this.destination, required this.context});

  void handleScreenSwap() {
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => destination));                  
  }

@override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          TextButton(
            child: Text("Changer de vue"),
            onPressed: handleScreenSwap
          )
        ],
      )
    );
  }
}