import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article.dart';
import 'package:la_bonne_franquette_front/models/order.dart';

class CardBody extends StatelessWidget {
  final Order order;

  CardBody(this.order);

  @override
  Widget build(BuildContext context) {
    List<Article> articles = order.getArticlesConcatMenus();
    return ListView.builder(
        shrinkWrap: true,
        itemCount: articles.length,
        itemBuilder: (context, articleIndex) {
          return Column(
            children: [
              ListTile(
                title: Text(
                    '${articles[articleIndex].quantity} ${articles[articleIndex].name}',
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              ...articles[articleIndex]
                  .ingredients
                  .map((ingredient) => ListTile(
                        leading: Icon(Icons.remove),
                        title: Text(
                          ' ${ingredient.name}',
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontSize: 16),
                        ),
                      )),
              ...articles[articleIndex].addons.map((extra) => ListTile(
                    leading: Icon(Icons.add),
                    title: Text(
                      ' ${extra.name}',
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 16),
                    ),
                  )),
            ],
          );
        });
  }
}
