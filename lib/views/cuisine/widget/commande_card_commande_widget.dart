import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:la_bonne_franquette_front/models/commande.dart';

class CommandeCardCommandeWidget extends StatelessWidget {
  final Commande commande;

  CommandeCardCommandeWidget(this.commande);



  @override
  Widget build(BuildContext context) {
    List<Article> articles = commande.getArticlesConcatMenus();
    return Container(
      margin: EdgeInsets.all(15.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: articles.length,
        itemBuilder: (context, articleIndex) {
          return Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text('${articles[articleIndex].quantite} ${articles[articleIndex].nom}'),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: articles[articleIndex].extraSet.length,
                  itemBuilder: (context, extraIndex) {
                    return ListTile(
                      title: Text(
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          ' ${articles[articleIndex].extraSet[extraIndex].nom}'),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
