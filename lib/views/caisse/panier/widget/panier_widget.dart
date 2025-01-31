import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/models/selection.dart';
import 'package:la_bonne_franquette_front/services/provider/commande_notifier.dart';
import 'package:la_bonne_franquette_front/views/caisse/panier/viewmodel/panier_view_model.dart';
import 'package:la_bonne_franquette_front/views/caisse/panier/widget/article_card.dart';
import 'package:la_bonne_franquette_front/views/caisse/panier/widget/menu_card.dart';
import 'package:provider/provider.dart';

import '../../../../models/article.dart';

class PanierWidget extends HookWidget {
  final double height;

  PanierWidget({required this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 0, 0),
        child: Consumer<CommandeNotifier>(
          builder: (context, commandeNotifier, _) {
            final menus = commandeNotifier.currentCommande.menus ?? [];
            final articles = commandeNotifier.currentCommande.articles ?? [];
            final items = [...menus, ...articles];

            return Column(
              children: [
                items.isNotEmpty
                    ? SizedBox(
                        height: height - 150,
                        child: ListView(
                          children: items.map<Widget>((item) {
                            if (item is Selection) {
                              return MenuCard(menu: item);
                            } else if (item is Article) {
                              return ArticleCard(article: item);
                            } else {
                              return SizedBox.shrink();
                            }
                          }).toList(),
                        ),
                      )
                    : SizedBox(),
                items.isNotEmpty
                    ? Center(
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                onPressed: () {
                                  context.go("/commande");
                                },
                                child: Text(
                                  'Valider',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ),
                            Text(
                              'Total en cours : ${(commandeNotifier.currentCommande.prixHT! / 100).toStringAsFixed(2) ?? '0'} €',
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          ],
                        ),
                      )
                    : SizedBox(),
              ],
            );
          },
        ));
  }
}
