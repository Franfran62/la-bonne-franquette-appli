import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/selection.dart';
import 'package:la_bonne_franquette_front/services/provider/commande_notifier.dart';
import 'package:la_bonne_franquette_front/views/caisse/viewmodel/caisse_view_model.dart';
import 'package:la_bonne_franquette_front/widgets/panier/badge_modifie.dart';
import 'article_info.dart';

class MenuCard extends HookWidget {
  final Selection menu;
  CommandeNotifier commandeNotifier = CommandeNotifier();

  MenuCard({required this.menu, super.key});

  void ajout() {
    commandeNotifier.addMenu(menu);
  }

  void suppression() {
    commandeNotifier.removeMenu(menu);
  }

@override
Widget build(BuildContext context) {

  return Card(
        color: menu.isModified
            ? Color(0xFFE8F4FD)
            : Color(0xFFF8F9FA),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (menu.isModified)
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                      child: BadgeModifie(),
                    ),
                  ],
                ),
            Row(
              children: [
                IconButton(onPressed: ajout, icon: Icon(Icons.add)),
                Text(menu.quantite.toString()),
                Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)),
                Expanded(
                  child: Text(
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    menu.nom,
                  ),
                ),
                IconButton(onPressed: suppression, icon: Icon(Icons.remove)),
              ],
            ),
            ...menu.articles.map((a) => ArticleInfos(article: a)),
          ],
        ),
      );
}

}