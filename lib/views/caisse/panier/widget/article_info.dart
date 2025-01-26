import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:la_bonne_franquette_front/views/caisse/panier/widget/article_extras_and_ingredients.dart';

class ArticleInfos extends StatelessWidget {

  final Article article;
  
  const ArticleInfos({
    required this.article,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            maxLines: 1,
            overflow: TextOverflow.clip,
            article.nom,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.start,
          ),
          ArticleExtrasAndIngredients(article: article),
        ],
      ),
    );
  }
}

