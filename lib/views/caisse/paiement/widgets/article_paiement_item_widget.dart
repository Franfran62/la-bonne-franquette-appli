import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article.dart';
import 'package:la_bonne_franquette_front/models/enums/PaymentChoice.dart';
import 'package:la_bonne_franquette_front/models/selection.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article_paiement.dart';
import 'package:la_bonne_franquette_front/services/provider/paiement_notifier.dart';
import 'package:la_bonne_franquette_front/widgets/panier/article_extras_and_ingredients.dart';
import 'package:la_bonne_franquette_front/widgets/panier/article_info.dart';
import 'package:la_bonne_franquette_front/widgets/panier/badge_modifie.dart';

class ItemLineWidget extends HookWidget {
  final ArticlePaiement item;
  final bool isPaid;
  bool isSelected = false;

  ItemLineWidget({
    required this.item,
    required this.isPaid,
    isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final PaiementNotifier paiementNotifier = PaiementNotifier();

    Color defineBackGroundColor() {
      if (isPaid) {
        return Color.fromARGB(255, 68, 207, 131);
      }
      return item.article.isModified ? Color(0xFFFFF9C4) : Color(0xFFF8F9FA);
    }

    void onTap() {
      if (paiementNotifier.selectedPayment == PaymentChoice.selection && !isPaid) {
        paiementNotifier.currentSelection.contains(item)
            ? paiementNotifier.removeSelection(item)
            : paiementNotifier.addSelection(item);
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
          color: defineBackGroundColor(),
          shape: paiementNotifier.currentSelection.contains(item)
              ? RoundedRectangleBorder(
                  side: BorderSide(color: Colors.green, width: 3.0),
                  borderRadius: BorderRadius.circular(4.0),
                )
              : null,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.article.isModified)
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                        child: BadgeModifie(),
                      ),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 12.0)),
                    Expanded(
                        child: Text(
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      "1 ${item.article.nom}",
                    )),
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.end,
                         style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                         "${item.article.prixTTC / 100} €"
                    )),
                  ],
                ),
                if (item.article is Article &&
                    (item.article.ingredients.isNotEmpty ||
                        item.article.extraSet.isNotEmpty))
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child:
                          ArticleExtrasAndIngredients(article: item.article!)),
                if (item.article is Selection)
                  ...item.article.articles.map(
                    (a) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: ArticleInfos(article: a)),
                  ),
              ],
            ),
          )),
    );
  }
}
