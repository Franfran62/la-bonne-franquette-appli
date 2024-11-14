import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/menu.dart';
import 'package:la_bonne_franquette_front/views/caisse/viewmodel/caisse_view_model.dart';

class CaisseMenuListView extends StatelessWidget {
  final List<Menu>? menus;
  final CaisseViewModel viewModel = CaisseViewModel();

  CaisseMenuListView({required this.menus, super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      children: menus != null && menus!.isNotEmpty ? [
        ...menus!
            .map((element) => Padding(
          padding: EdgeInsets.all(2.0),
          child: ElevatedButton(
            onPressed: () => {
              viewModel.ajouterMenuAuPanier(element)
            },
            child: Text(element.nom, textAlign: TextAlign.center,textScaler: TextScaler.linear(1)),
          ),
        )),
      ] : [
        CircularProgressIndicator()
      ],
    );
  }
}