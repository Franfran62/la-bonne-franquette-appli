import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/menu_commande.dart';

import '../viewmodel/panier_view_model.dart';

class MenuCard extends HookWidget {
  final MenuCommande menu;
  final PanierViewModel viewModel = PanierViewModel();

  MenuCard({required this.menu, super.key});

  void ajout() {
    viewModel.ajouterMenuAuPanier(menu);
  }

  void suppression() {
    viewModel.supprimerMenu(menu);
  }
//TODO Gérer les modification des articles du menu ainsi que la couleur de la card

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.greenAccent,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(onPressed: ajout, icon: Icon(Icons.add)),
              IconButton(onPressed: suppression, icon: Icon(Icons.remove)),
              Text(menu.quantite.toString()),
              Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)),
              Expanded(
                  child: Text(
                      maxLines: 1, overflow: TextOverflow.clip, menu.nom)),
            ],
          ),
        ],
      ),
    );
  }
}
