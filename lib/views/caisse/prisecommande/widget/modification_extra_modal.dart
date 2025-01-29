import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/extra.dart';
import 'package:la_bonne_franquette_front/services/stores/database_service.dart';
import 'package:la_bonne_franquette_front/views/caisse/prisecommande/viewmodel/caisse_view_model.dart';

class ModificationExtraModal extends StatelessWidget {
  final int produitId;
  final ValueNotifier<List<Extra>> extrasPourProduit;
  final CaisseViewModel caisseViewModel = CaisseViewModel();

  ModificationExtraModal({
    required this.produitId,
    required this.extrasPourProduit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Extra>>(
      future: DatabaseService.findExtrasByProduitId(produitId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox();
        }

        final extras = snapshot.data!;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Center(
                child: Text(
                  "Extras",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            ...extras.map((extra) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return InkWell(
                        child: Row(
                          children: [
                            Text(
                              extra.nom,
                              style: Theme.of(context).textTheme.bodyMedium
                              ),
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
        );
      },
    );
  }
}
