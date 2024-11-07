import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/menu.dart';
import 'package:la_bonne_franquette_front/views/caisse/viewmodel/caisse_view_model.dart';

class CaisseMenuListView extends StatelessWidget {
  final List<Menu>? list;
  final CaisseViewModel viewModel = CaisseViewModel();

  CaisseMenuListView({required this.list, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: [
        ...list!
            .map((element) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: ElevatedButton(
            onPressed: () => {
              viewModel.ajouterMenuAuPanier(element)
            },
            child: Text(element.nom),
          ),
        )),
      ],
    );
  }
}