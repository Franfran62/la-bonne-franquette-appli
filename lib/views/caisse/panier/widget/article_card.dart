import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:la_bonne_franquette_front/views/caisse/panier/viewmodel/panier_view_model.dart';
import 'package:la_bonne_franquette_front/views/caisse/panier/widget/article_extras_and_ingredients.dart';

class ArticleCard extends HookWidget {
  final Article article;
  final PanierViewModel viewModel = PanierViewModel();

  ArticleCard({required this.article, super.key});

  void ajout() {
    PanierViewModel().ajouterAuPanier(article);
  }

  void suppression() {
    PanierViewModel().supprimerArticle(article);
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = useState(
        article.isModified
            ? Colors.redAccent
            : Colors.greenAccent);
    return Card(
      color: backgroundColor.value,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(onPressed: ajout, icon: Icon(Icons.add)),
              IconButton(onPressed: suppression, icon: Icon(Icons.remove)),
              Text(article.quantite.toString()),
              Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)),
              Expanded(
                  child: Text(
                      maxLines: 1, overflow: TextOverflow.clip, article.nom)),
            ],
          ),
          if (article.ingredients.isNotEmpty || article.extraSet.isNotEmpty)
            ArticleExtrasAndIngredients(article: article),
        ],
      ),
    );
  }
}
