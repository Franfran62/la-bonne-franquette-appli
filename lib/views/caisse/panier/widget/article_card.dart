import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:la_bonne_franquette_front/views/caisse/panier/viewmodel/panier_view_model.dart';
import 'package:la_bonne_franquette_front/views/caisse/panier/widget/article_extras_and_ingredients.dart';
import 'package:la_bonne_franquette_front/views/caisse/panier/widget/badge_modifie.dart';

class ArticleCard extends HookWidget {
  final Article article;
  final PanierViewModel viewModel = PanierViewModel();

  ArticleCard({required this.article, super.key});

  void ajout(BuildContext context) {
    PanierViewModel().ajouterAuPanier(article);
    (context as Element).markNeedsBuild();
  }

  void suppression(BuildContext context) {
    PanierViewModel().supprimerArticle(article);
    (context as Element).markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: article.isModified
            ? Color(0xFFE8F4FD)
            : Color(0xFFF8F9FA),
      child: Column(
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
      ),
    );
  }
}
