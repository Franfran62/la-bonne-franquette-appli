import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/ingredient.dart';
import 'package:la_bonne_franquette_front/services/stores/database_service.dart';

class ModificationIngredientModal extends StatelessWidget {
  final int produitId;
  final ValueNotifier<List<Ingredient>> ingredientsARetirer;

  ModificationIngredientModal({
    required this.produitId,
    required this.ingredientsARetirer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Ingredient>>(
      future: DatabaseService.findIngredientsByProduitId(produitId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox();
        }

        final ingredients = snapshot.data!;
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
            ...ingredients.map((ingredient) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return InkWell(
                        child: Row(
                          children: [
                            Text(
                              ingredient.nom,
                              style: Theme.of(context).textTheme.bodyMedium
                              ),
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
        );
      },
    );
  }
}
