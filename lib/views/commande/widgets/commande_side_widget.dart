import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:la_bonne_franquette_front/models/selection.dart';
import 'package:la_bonne_franquette_front/widgets/panier/widget/article_card.dart';
import 'package:la_bonne_franquette_front/widgets/panier/widget/menu_card.dart';

class CommandeSideWidget extends StatelessWidget {

  final List<dynamic> items;
  final String title;
  const CommandeSideWidget({super.key, required this.items, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 100,
      child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        title,
                        style: Theme.of(context).textTheme.headlineMedium
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 20)),  
                    Expanded(
                      child: 
                      items.isNotEmpty
                        ? ListView(
                              children: items.map<Widget>((item) {
                                if (item is Selection) {
                                  return MenuCard(menu: item);
                                } else if (item is Article) {
                                  return ArticleCard(article: item);
                                } else {
                                  return SizedBox.shrink();
                                }
                              }).toList(),
                            )
                        : SizedBox(),
                      ),
                  ],
                ),
      );
  }
}