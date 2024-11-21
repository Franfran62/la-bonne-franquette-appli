import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:la_bonne_franquette_front/views/panier/widget/article_extras_and_ingredients.dart';

class ArticleInfos extends StatelessWidget {

  final Article article;
  final double fontSize;
  
  const ArticleInfos({
    required this.article,
    this.fontSize = 14,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: Column(
        children: [
          Text(
            maxLines: 1,
            overflow: TextOverflow.clip,
            article.nom,
            style: TextStyle(fontSize: fontSize),
            textAlign: TextAlign.start,
          ),
          ArticleExtrasAndIngredients(article: article),
        ],
      ),
    );
  }
}

