import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article.dart';

class ArticleExtrasAndIngredients extends StatelessWidget {
  const ArticleExtrasAndIngredients({
    super.key,
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (article.extraSet.isNotEmpty)
          ...article.extraSet.map((e) => Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 8.0),
                child: Icon(Icons.add_circle_outline),
              ),
              Text(
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.clip,
                e.nom,
              ),
            ],
          )),
        if (article.ingredients.isNotEmpty)
          ...article.ingredients.map((e) => Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 8.0),
                child: Icon(Icons.remove_circle_outline),
              ),
              Text(
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.clip,
                e.nom,
              ),
            ],
          )),
          Padding(padding: EdgeInsets.only(bottom: 8.0)),
      ],
    );
  }
}