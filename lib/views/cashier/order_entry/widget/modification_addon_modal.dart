import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/addon.dart';
import 'package:la_bonne_franquette_front/services/stores/database_request.dart';

class ModificationAddonModal extends StatelessWidget {
  final int productId;
  final ValueNotifier<List<Addon>> addons;

  const ModificationAddonModal({
    required this.productId,
    required this.addons,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Addon>>(
      future: DatabaseRequest.findAllAddonByProductId(productId),
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
                  "Extras disponibles",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 12)),
            ...extras.map((addon) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return InkWell(
                        child: Row(
                          children: [
                            Text(addon.name,
                                style: Theme.of(context).textTheme.bodyMedium),
                            if (addons.value.contains(addon))
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Icon(Icons.check),
                              ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            if (!addons.value.contains(addon)) {
                              addons.value.add(addon);
                            } else {
                              addons.value.remove(addon);
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
