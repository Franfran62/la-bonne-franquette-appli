import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/wrapper/selection.dart';
import 'package:la_bonne_franquette_front/services/provider/order_notifier.dart';
import 'package:la_bonne_franquette_front/widgets/cart/modification_badge.dart';
import 'article_info.dart';

class CardMenu extends HookWidget {
  final Selection menu;
  OrderNotifier orderNotifier = OrderNotifier();

  CardMenu({required this.menu, super.key});

  void add() {
    orderNotifier.addMenu(menu);
  }

  void remove() {
    orderNotifier.removeMenu(menu);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (menu.modified)
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
            IconButton(onPressed: add, icon: Icon(Icons.add)),
            Text(menu.quantity.toString()),
            Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)),
            Expanded(
              child: Text(
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.clip,
                menu.name,
              ),
            ),
            IconButton(onPressed: remove, icon: Icon(Icons.remove)),
          ],
        ),
        ...menu.articles.map((a) => ArticleInfo(article: a)),
      ],
    );
  }
}
