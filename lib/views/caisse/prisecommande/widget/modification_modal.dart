import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/extra.dart';
import 'package:la_bonne_franquette_front/models/ingredient.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/views/caisse/prisecommande/viewmodel/caisse_view_model.dart';
import 'package:la_bonne_franquette_front/views/caisse/prisecommande/widget/modification_ingredient_modal.dart';
import 'package:la_bonne_franquette_front/views/caisse/prisecommande/widget/modification_extra_modal.dart';

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
                      child: ModificationIngredientModal(
                        produitId: produitAModifier.id,
                        ingredientsARetirer: ingredientsARetirer,
                      ),
                    ),
                    Expanded(
                      child: ModificationExtraModal(
                        extrasPourProduit: extrasPourProduit,
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
  }
}