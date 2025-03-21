import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/extra.dart';
import 'package:la_bonne_franquette_front/models/ingredient.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/views/caisse/prisedecommande/viewmodel/prisedecommande_view_model.dart';
import 'package:la_bonne_franquette_front/views/caisse/prisedecommande/widget/modification_ingredient_modal.dart';
import 'package:la_bonne_franquette_front/views/caisse/prisedecommande/widget/modification_extra_modal.dart';

class ModificationModal extends HookWidget {
  final Produit produitAModifier;
  final Function(Map<String, List>) onModificationsSelected;
  final PriseDeCommandeViewModel caisseViewModel = PriseDeCommandeViewModel();

  ModificationModal({
    required this.produitAModifier,
    required this.onModificationsSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final extrasPourProduit = useState(<Extra>[]);
    final ingredientsARetirer = useState(<Ingredient>[]);

    return Stack(
      alignment: Alignment.center,
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
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ModificationIngredientModal(
                        produitId: produitAModifier.id,
                        ingredientsARetirer: ingredientsARetirer,
                      ),
                    ),
                    Expanded(
                      child: ModificationExtraModal(
                        produitId: produitAModifier.id,
                        extrasPourProduit: extrasPourProduit,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
        Positioned(
          bottom: 15,
          width: 150,
          child: ElevatedButton(
            style: Theme.of(context).elevatedButtonTheme.style,
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
  }
}
