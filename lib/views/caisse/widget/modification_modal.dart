import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/extra.dart';
import 'package:la_bonne_franquette_front/models/ingredient.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/views/caisse/viewmodel/caisse_view_model.dart';

class ModificationModal extends HookWidget {
  final Produit produitAModifier;
  final Function(Map<String, List>) onModificationsSelected;
  final CaisseViewModel caisseViewModel = CaisseViewModel();

  ModificationModal({
    required this.produitAModifier,
    required this.onModificationsSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final extrasPourProduit = useState(<Extra>[]);
    final ingredientsARetirer = useState(<Ingredient>[]);

    return FutureBuilder<List<Extra>>(
      future: caisseViewModel.getExtras(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox();
        }

        final extrasSource = snapshot.data!;
        return Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Center(
                      child: Text(
                        produitAModifier.nom,
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 24.0),
                                child: Center(
                                  child: Text(
                                    "Ingrédients",
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                              ...produitAModifier.ingredients.map((ingredient) => Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: StatefulBuilder(
                                      builder: (context, setState) {
                                        return InkWell(
                                          child: Row(
                                            children: [
                                              Text(ingredient.nom),
                                              if (ingredientsARetirer.value.contains(ingredient))
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Icon(Icons.close),
                                                ),
                                            ],
                                          ),
                                          onTap: () {
                                            setState(() {
                                              if (!ingredientsARetirer.value.contains(ingredient)) {
                                                ingredientsARetirer.value.add(ingredient);
                                              } else {
                                                ingredientsARetirer.value.remove(ingredient);
                                              }
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 24.0),
                                child: Center(
                                  child: Text(
                                    "Extras",
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                              ...extrasSource.map((extra) => Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: StatefulBuilder(
                                      builder: (context, setState) {
                                        return InkWell(
                                          child: Row(
                                            children: [
                                              Text(extra.nom),
                                              if (extrasPourProduit.value.contains(extra))
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Icon(Icons.check),
                                                ),
                                            ],
                                          ),
                                          onTap: () {
                                            setState(() {
                                              if (!extrasPourProduit.value.contains(extra)) {
                                                extrasPourProduit.value.add(extra);
                                              } else {
                                                extrasPourProduit.value.remove(extra);
                                              }
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 250.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Map<String, List> modifications = {
                            "ingredients": ingredientsARetirer.value,
                            "extras": extrasPourProduit.value,
                          };
                          onModificationsSelected(modifications);
                        },
                        child: Text("Valider"),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
              ),
            ),
          ],
        );
      },
    );
  }
}