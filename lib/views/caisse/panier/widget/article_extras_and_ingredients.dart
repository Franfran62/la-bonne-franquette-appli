import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/article.dart';

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
        if (article.extraSet != null && article.extraSet.isNotEmpty)
          ...article.extraSet.map((e) => Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Icon(Icons.add),
              ),
              Text(
                style: TextStyle(fontSize: 14),
                overflow: TextOverflow.clip,
                e.nom,
              ),
            ],
          )),
        if (article.ingredients != null && article.ingredients.isNotEmpty)
          ...article.ingredients.map((e) => Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Icon(Icons.remove),
              ),
              Text(
                style: TextStyle(fontSize: 14),
                overflow: TextOverflow.clip,
                e.nom,
              ),
            ],
          )),
      ],
    );
  }
}