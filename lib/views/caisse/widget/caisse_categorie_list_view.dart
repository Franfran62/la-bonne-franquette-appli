import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/categorie.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/views/caisse/widget/caisse_produit_list_view.dart';
import 'package:la_bonne_franquette_front/views/caisse/widget/caisse_sous_categorie_list_view.dart';
import 'package:la_bonne_franquette_front/views/caisse/widget/element_button.dart';

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
    Map<String, List> defaultList = {
      "produits": <Produit>[],
      "sous-categories": <Categorie>[],
    };
    final listAffiche = useState<Map<String, List>>(defaultList);

    updateProduitsAffiches(Map<String, List> nouvelleList) {
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
                            element: element.nom,
                            tailleText: tailleText,
                            onPressed: () {
                              updateProduitsAffiches({
                                "produits": element.produits,
                                "sous-categories": element.sousCategories
                              });
                            },
                            isSelected: (element.produits ==
                                    listAffiche.value["produits"] ||
                                element.sousCategories ==
                                    listAffiche.value["sous-categories"]),
                          ),
                        )),
                  ]
                : [CircularProgressIndicator()],
          ),
        ),
        SizedBox(
          height: taille * 2,
          child: listAffiche.value.isNotEmpty
              ? listAffiche.value["sous-categories"]!.isNotEmpty
                  ? CaisseSousCategorieListView(
                      categories: listAffiche.value['sous-categories']
                          as List<Categorie>,
                      taille: taille,
                      tailleText: tailleText,
                    )
                  : listAffiche.value["produits"]!.isNotEmpty
                      ? Column(
                          children: [
                            SizedBox(
                              height: taille,
                              child: CaisseProduitListView(
                                produits: listAffiche.value["produits"]
                                    as List<Produit>,
                                tailleText: tailleText,
                              ),
                            ),
                            SizedBox(
                              height: taille,
                            )
                          ],
                        )
                      : SizedBox()
              : SizedBox(),
        )
      ],
    );
  }
}
