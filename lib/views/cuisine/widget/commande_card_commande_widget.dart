import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article.dart';
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
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text('${articles[articleIndex].quantite} ${articles[articleIndex].nom}'),
                ),
                ...articles[articleIndex].ingredients.map((ingredient) => ListTile(
                      leading: Icon(Icons.remove),
                      title: Text(
                        ' ${ingredient.nom}',
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 16),
                      ),
                    )),
                ...articles[articleIndex].extraSet.map((extra) => ListTile(
                      leading: Icon(Icons.add),
                      title: Text(
                        ' ${extra.nom}',
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 16),
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}