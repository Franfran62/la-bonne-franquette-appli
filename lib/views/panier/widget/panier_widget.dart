import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/views/panier/viewmodel/panier_view_model.dart';
import 'package:la_bonne_franquette_front/views/panier/widget/article_card.dart';

import '../../../models/article.dart';

class PanierWidget extends HookWidget {
  final double height;

  PanierWidget({required this.height, super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = useMemoized(() => PanierViewModel());

    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: ValueListenableBuilder<List<Article>>(
        valueListenable: viewModel.articlesNotifier,
        builder: (context, articles, _) {
          return ListView(children: [
            ...articles.map((e) => ArticleCard(
                  article: e,
                )),
            articles.isNotEmpty ? Center(
              child: Container(
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    context.go("/panier");
                  },
                  child: const Text('Valider'),
                ),
              ),
            ) :  SizedBox(),
          ]);
        },
      ),
    );
  }
}
