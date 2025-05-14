import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/addon.dart';
import 'package:la_bonne_franquette_front/models/ingredient.dart';
import 'package:la_bonne_franquette_front/models/product.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_entry/widget/modification_ingredient_modal.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_entry/widget/modification_addon_modal.dart';

class ModificationModal extends HookWidget {
  final Product product;
  final Function(Map<String, List>) onModificationsSelected;

  const ModificationModal({
    required this.product,
    required this.onModificationsSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final addons = useState(<Addon>[]);
    final ingredients = useState(<Ingredient>[]);

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
                    product.name,
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
                        productId: product.id,
                        ingredients: ingredients,
                      ),
                    ),
                    Expanded(
                      child: ModificationAddonModal(
                        productId: product.id,
                        addons: addons,
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
                "ingredients": ingredients.value,
                "addons": addons.value,
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
