import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/models/menu_commande.dart';
import 'package:la_bonne_franquette_front/views/panier/viewmodel/panier_view_model.dart';
import 'package:la_bonne_franquette_front/views/panier/widget/article_card.dart';
import 'package:la_bonne_franquette_front/views/panier/widget/menu_card.dart';

import '../../../models/article.dart';

class PanierWidget extends HookWidget {
  final double height;

  PanierWidget({required this.height, super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = useMemoized(() => PanierViewModel());

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
      //padding: const EdgeInsets.only(left: 20.0),
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: ValueNotifier<List<dynamic>>([
              ...viewModel.menusNotifier.value,
              ...viewModel.articlesNotifier.value
            ]),
            builder: (context, items, _) {
              return items.isNotEmpty
                  ? SizedBox(
                height: height-150,
                    child: ListView(children: [
                        ...items.map<Widget>((item) {
                          if (item is MenuCommande) {
                            return MenuCard(menu: item);
                          } else if (item is Article) {
                            return ArticleCard(article: item);
                          } else {
                            return SizedBox.shrink();
                          }
                        }).toList(),
                      ]),
                  )
                  : SizedBox();
            },
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  context.go("/panier");
                },
                child: const Text('Valider'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
/*

Container(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                context.go("/panier");
              },
              child: const Text('Valider'),
            ),
          ),
 */
