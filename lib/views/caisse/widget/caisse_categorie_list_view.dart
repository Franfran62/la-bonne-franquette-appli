import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/categorie.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/views/caisse/widget/caisse_produit_list_view.dart';

import '../viewmodel/caisse_view_model.dart';

class CaisseCategorieListView extends HookWidget {
  final List<Categorie>? categories;
  final double taille;
  final TextScaler tailleText;

  CaisseCategorieListView(
      {super.key,
      required this.categories,
      required this.taille,
      required this.tailleText});

  final CaisseViewModel viewModel = CaisseViewModel();

  @override
  Widget build(BuildContext context) {
    List<Produit> defaultList = [];
    final produitsAffiches = useState(defaultList);

    updateProduitsAffiches(List<Produit> produits) {
      produitsAffiches.value = produits;
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
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: element.produits ==
                                      produitsAffiches.value
                                  ? MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.tertiary)
                                  : MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.primary),
                            ),
                            onPressed: () =>
                                {updateProduitsAffiches(element.produits)},
                            child: Text(
                              element.nom,
                              textAlign: TextAlign.center,
                              textScaler: tailleText,
                            ),
                          ),
                        )),
                  ]
                : [CircularProgressIndicator()],
          ),
        ),
        SizedBox(
          height: taille,
          child: produitsAffiches.value.isNotEmpty
              ? CaisseProduitListView(
                  produits: produitsAffiches.value,
                  tailleText: tailleText,
                  onProduitSelected: () => updateProduitsAffiches(defaultList),
                )
              : SizedBox(),
        )
      ],
    );
  }
}
