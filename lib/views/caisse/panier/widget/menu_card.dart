import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/selection.dart';

import '../viewmodel/panier_view_model.dart';
import 'article_info.dart';

class MenuCard extends HookWidget {
  final Selection menu;
  final PanierViewModel viewModel = PanierViewModel();

  MenuCard({required this.menu, super.key});

  void ajout() {
    viewModel.ajouterQuantiteMenu(menu);
  }

  void suppression() {
    viewModel.supprimerMenu(menu);
  }

@override
Widget build(BuildContext context) {
  final backgroundColor = useState(Colors.amberAccent);

  return Card(
        color: backgroundColor.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(onPressed: ajout, icon: Icon(Icons.add)),
                IconButton(onPressed: suppression, icon: Icon(Icons.remove)),
                Text(menu.quantite.toString()),
                Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)),
                Expanded(
                  child: Text(
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    menu.nom,
                  ),
                ),
              ],
            ),
            ...menu.articles.map((a) => ArticleInfos(article: a)),
          ],
        ),
      );
}

}