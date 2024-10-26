import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/views/panier/viewmodel/panier_view_model.dart';
import 'package:la_bonne_franquette_front/views/panier/widget/article_card.dart';

class PanierWidget extends HookWidget {
  final double height;

  PanierWidget({required this.height, super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = useMemoized(() => PanierViewModel());

    final articles = useListenable(viewModel.articlesNotifier);

    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: ListView(children: [
        ...articles.value
            .map((e) => ArticleCard(
                article: e, quantite: 1, ajout: () {}, suppression: () {}))
            .toList(),
      ]),
    );
  }
}
