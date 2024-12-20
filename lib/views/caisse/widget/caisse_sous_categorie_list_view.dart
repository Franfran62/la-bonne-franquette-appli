import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';

import '../../../models/categorie.dart';
import '../viewmodel/caisse_view_model.dart';
import 'caisse_produit_list_view.dart';
import 'element_button.dart';

class CaisseSousCategorieListView extends HookWidget {
  final List<Categorie>? categories;
  final double taille;
  final TextScaler tailleText;

  CaisseSousCategorieListView({
    super.key,
    required this.categories,
    required this.taille,
    required this.tailleText,
  });

  final CaisseViewModel viewModel = CaisseViewModel();

  @override
  Widget build(BuildContext context) {
    List<Produit> defaultList = [];
    final listAffiche = useState<List<Produit>>(defaultList);

    updateProduitsAffiches(List<Produit> nouvelleList) {
      listAffiche.value = nouvelleList;
    }

    return Column(
      children: [
        SizedBox(
          height: taille,
          child: GridView(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: categories != null && categories!.isNotEmpty
                ? [
                    ...categories!.map((element) => Padding(
                          padding: EdgeInsets.all(2.0),
                          child: ElementButton(
                            element: element,
                            tailleText: tailleText,
                            onPressed: () =>
                                updateProduitsAffiches(element.produits),
                            isSelected: element.produits == listAffiche.value,
                          ),
                        )),
                  ]
                : [CircularProgressIndicator()],
          ),
        ),
        SizedBox(
          height: taille,
          child: listAffiche.value.isNotEmpty
              ? CaisseProduitListView(
                  produits: listAffiche.value,
                  tailleText: tailleText,
                )
              : SizedBox(),
        )
      ],
    );
  }
}
