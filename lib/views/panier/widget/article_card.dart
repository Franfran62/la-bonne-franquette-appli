import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:la_bonne_franquette_front/views/panier/viewmodel/panier_view_model.dart';

class ArticleCard extends HookWidget {

  final Article article;
  final PanierViewModel viewModel = PanierViewModel();

  ArticleCard(
      {required this.article,
      super.key});

  void ajout() {
    PanierViewModel().ajouterArticle(article);
  }

  void suppression() {
    PanierViewModel().supprimerArticle(article);
  }

  @override
  Widget build(BuildContext context) {
  return Card(
    color: (article.ingredients.isNotEmpty || article.extraSet.isNotEmpty) ? Colors.redAccent : Colors.greenAccent,
    child: Column(
      children: [
        Row(
          children: [
            IconButton(onPressed: ajout, icon: Icon(Icons.add)),
            IconButton(onPressed: suppression, icon: Icon(Icons.remove)),
            Text(article.quantite.toString()),
            Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)),
            Expanded(child: Text(maxLines: 1, overflow: TextOverflow.clip, article.nom)),
          ],
        ),
        if (article.ingredients.isNotEmpty || article.extraSet.isNotEmpty)
          Column(
            children: [
              if (article.extraSet != null && article.extraSet.isNotEmpty)
                ...article.extraSet.map((e) => Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 100.0),
                          child: Icon(Icons.add),
                        ),
                        Text(
                          style: TextStyle(fontSize: 14),
                          e.nom,
                        ),
                      ],
                    )),
              if (article.ingredients != null && article.ingredients.isNotEmpty)
                ...article.ingredients.map((e) => Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 100.0),
                          child: Icon(Icons.remove),
                        ),
                        Text(
                          style: TextStyle(fontSize: 14),
                          e.nom,
                        ),
                      ],
                    )),
            ],
          ),
      ],
    ),
  );
}
}
