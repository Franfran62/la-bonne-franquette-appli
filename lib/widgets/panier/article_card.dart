import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article.dart';
import 'package:la_bonne_franquette_front/services/provider/commande_notifier.dart';
import 'package:la_bonne_franquette_front/views/caisse/viewmodel/caisse_view_model.dart';
import 'package:la_bonne_franquette_front/widgets/panier/article_extras_and_ingredients.dart';
import 'package:la_bonne_franquette_front/widgets/panier/badge_modifie.dart';

class ArticleCard extends HookWidget {
  final Article article;
  CommandeNotifier commandeNotifier = CommandeNotifier();

  ArticleCard({required this.article, super.key});

  void ajout(BuildContext context) {
    commandeNotifier.addArticle(article);
    (context as Element).markNeedsBuild();
  }

  void suppression(BuildContext context) {
    commandeNotifier.removeArticle(article);
    (context as Element).markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
           if (article.isModified)
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                      child: BadgeModifie(),
                    ),
                  ],
                ),
          Row(
            children: [
              IconButton(onPressed: () => ajout(context), icon: Icon(Icons.add)),
              Text(article.quantite.toString()),
              Padding(padding: EdgeInsets.symmetric(horizontal: 1.0)),
              Expanded(
                  child: Text(
                    style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1, 
                      overflow: TextOverflow.clip, 
                      article.nom)
              ),
              IconButton(onPressed: () => suppression(context), icon: Icon(Icons.remove)),
            ],
          ),
          if (article.ingredients.isNotEmpty || article.extraSet.isNotEmpty)
             ArticleExtrasAndIngredients(article: article),      
        ],
      );
  }
}
