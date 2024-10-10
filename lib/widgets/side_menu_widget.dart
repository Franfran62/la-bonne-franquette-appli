import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/services/api/connection_service.dart';

class SideMenuWidget extends StatelessWidget{

  final Widget destination;
  final BuildContext context;
  final GlobalKey<ScaffoldState> scaffoldKey; 

  const SideMenuWidget({super.key, required this.destination, required this.context, required this.scaffoldKey});

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
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 17,
                ),
                const Icon(
                  Icons.logout,
                  color: Colors.red,
                  ),
                TextButton(
                  onPressed: () async => await ConnectionService.logout(context),
                  child: const Text("Déconnexion", style: TextStyle( color: Colors.red, 
                                                                        fontSize: 20, 
                                                                        fontWeight: FontWeight.normal
                                                                        )
                  ),
                ),
              ],
            ),]
          )
        ],
      )
    );
  }
}