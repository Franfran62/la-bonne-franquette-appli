import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';

class SideMenuWidget extends StatelessWidget{

  final StatefulWidget destination;
  final BuildContext context;
  final GlobalKey<ScaffoldState> scaffoldKey; 

  SideMenuWidget({super.key, required this.destination, required this.context, required this.scaffoldKey});

  void handleScreenSwap() {
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => destination));                  
  }

@override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.zero,
                  bottomRight: Radius.zero
              ),
            ),
      child: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 5,
              ),
              IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => scaffoldKey.currentState?.closeDrawer()
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 17,
              ),
              const Icon(Icons.arrow_forward_rounded),
              TextButton(
                onPressed: handleScreenSwap,
                child: const Text("Changer de vue", style: TextStyle( color: Colors.black, 
                                                                      fontSize: 20, 
                                                                      fontWeight: FontWeight.normal
                                                                      )
                ),
              ),
            ],
          )
        ],
      )
    );
  }
}