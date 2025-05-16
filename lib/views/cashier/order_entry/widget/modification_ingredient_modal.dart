import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/ingredient.dart';
import 'package:la_bonne_franquette_front/services/stores/database_request.dart';

class ModificationIngredientModal extends StatelessWidget {
  final int productId;
  final ValueNotifier<List<Ingredient>> ingredients;

  const ModificationIngredientModal({
    required this.productId,
    required this.ingredients,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Ingredient>>(
      future: DatabaseRequest.findAllIngredientByProductId(productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox();
        }

        final data = snapshot.data!;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Center(
                child: Text(
                  "Ingrédients à retirer",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 12)),
            ...data.map((ingredient) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return InkWell(
                        child: Row(
                          children: [
                            Text(ingredient.name,
                                style: Theme.of(context).textTheme.bodyMedium),
                            if (ingredients.value.contains(ingredient))
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Icon(Icons.close),
                              ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            if (!ingredients.value
                                .contains(ingredient)) {
                              ingredients.value.add(ingredient);
                            } else {
                              ingredients.value.remove(ingredient);
                            }
                          });
                        },
                      );
                    },
                  ),
                )),
          ],
        );
      },
    );
  }
}
