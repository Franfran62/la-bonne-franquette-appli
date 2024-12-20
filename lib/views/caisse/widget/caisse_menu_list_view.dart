import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/menu.dart';
import 'package:la_bonne_franquette_front/views/caisse/viewmodel/caisse_view_model.dart';

import 'element_button.dart';

class CaisseMenuListView extends StatelessWidget {
  final List<Menu>? menus;
  final CaisseViewModel viewModel = CaisseViewModel();
  final double taille;
  final TextScaler tailleText;

  CaisseMenuListView(
      {required this.menus,
      required this.taille,
      required this.tailleText,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: taille,
      child: GridView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        children: menus != null && menus!.isNotEmpty
            ? [
                ...menus!.map((element) => Padding(
                      padding: EdgeInsets.all(2.0),
                      child: ElementButton(
                          element: element,
                          tailleText: tailleText,
                          onPressed: () =>
                              viewModel.ajouterMenuAuPanier(element)),
                    )),
              ]
            : [CircularProgressIndicator()],
      ),
    );
  }
}
