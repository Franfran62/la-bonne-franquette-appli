import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:la_bonne_franquette_front/views/panier/viewmodel/panier_view_model.dart';

class ArticleCard extends HookWidget {
  final Article article;
  int quantite;
  Function ajout;
  Function suppression;
  final PanierViewModel viewModel = PanierViewModel();

  ArticleCard(
      {required this.article,
      required this.quantite,
      required this.ajout,
      required this.suppression,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.greenAccent,
      child: Row(
        children: [
          IconButton(onPressed: ajout(), icon: Icon(Icons.add)),
          IconButton(onPressed: suppression(), icon: Icon(Icons.remove)),
          Text(quantite.toString()),
          Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
          Expanded(
            child:
                Text(maxLines: 2, overflow: TextOverflow.visible, article.nom),
          ),
        ],
      ),
    );
  }
}
