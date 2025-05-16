import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article.dart';
import 'package:la_bonne_franquette_front/models/enums/payment_choice.dart';
import 'package:la_bonne_franquette_front/models/wrapper/selection.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article_payment.dart';
import 'package:la_bonne_franquette_front/services/provider/payment_notifier.dart';
import 'package:la_bonne_franquette_front/widgets/cart/article_details.dart';
import 'package:la_bonne_franquette_front/widgets/cart/article_info.dart';

class ItemLineWidget extends HookWidget {
  final ArticlePayment item;
  final bool paid;
  bool selected = false;

  ItemLineWidget({
    required this.item,
    required this.paid,
    selected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final PaymentNotifier paymentNotifier = PaymentNotifier();

    Color defineBackGroundColor() {
      if (paid) {
        return Color.fromARGB(255, 68, 207, 131);
      }
      return item.article is Article &&
              (item.article.ingredients.isNotEmpty ||
                  item.article.addons.isNotEmpty)
          ? Color(0xFFE8F4FD)
          : Color(0xFFF8F9FA);
    }

    void onTap() {
      if (paymentNotifier.selectedPayment == PaymentChoice.selected && !paid) {
        paymentNotifier.selected.contains(item)
            ? paymentNotifier.removeSelection(item)
            : paymentNotifier.addSelection(item);
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
          color: defineBackGroundColor(),
          shape: paymentNotifier.selected.contains(item)
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 12.0)),
                    Expanded(
                        child: Text(
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      "1 ${item.article.name}",
                    )),
                    Expanded(
                        child: Text(
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            "${item.article.totalPrice / 100} €")),
                  ],
                ),
                if (item.article is Article &&
                    (item.article.ingredients.isNotEmpty ||
                        item.article.addons.isNotEmpty))
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: ArticleDetails(article: item.article!)),
                if (item.article is Selection)
                  ...item.article.articles.map(
                    (a) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: ArticleInfo(article: a)),
                  ),
              ],
            ),
          )),
    );
  }
}
