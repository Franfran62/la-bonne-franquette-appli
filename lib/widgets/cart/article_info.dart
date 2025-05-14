import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article.dart';
import 'package:la_bonne_franquette_front/widgets/cart/article_details.dart';

class ArticleInfo extends StatelessWidget {
  final Article article;

  const ArticleInfo({
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
            article.name,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.start,
          ),
          ArticleDetails(article: article),
        ],
      ),
    );
  }
}
