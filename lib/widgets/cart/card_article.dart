import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article.dart';
import 'package:la_bonne_franquette_front/services/provider/order_notifier.dart';
import 'package:la_bonne_franquette_front/widgets/cart/article_details.dart';
import 'package:la_bonne_franquette_front/widgets/cart/modification_badge.dart';

class CardArticle extends HookWidget {
  final Article article;
  OrderNotifier orderNotifier = OrderNotifier();

  CardArticle({required this.article, super.key});

  void add(BuildContext context) {
    orderNotifier.addArticle(article);
    (context as Element).markNeedsBuild();
  }

  void remove(BuildContext context) {
    orderNotifier.removeArticle(article);
    (context as Element).markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (article.modified)
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                child: ModificationBadge(),
              ),
            ],
          ),
        Row(
          children: [
            IconButton(onPressed: () => add(context), icon: Icon(Icons.add)),
            Text(article.quantity.toString()),
            Padding(padding: EdgeInsets.symmetric(horizontal: 1.0)),
            Expanded(
                child: Text(
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    article.name)),
            IconButton(
                onPressed: () => remove(context), icon: Icon(Icons.remove)),
          ],
        ),
        if (article.ingredients.isNotEmpty || article.addons.isNotEmpty)
          ArticleDetails(article: article),
      ],
    );
  }
}
