import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/views/caisse/paiement/widgets/date_livraison_choice_widget.dart';
import 'package:provider/provider.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article_paiement.dart';
import 'package:la_bonne_franquette_front/views/caisse/paiement/viewmodel/paiement_view_model.dart';
import 'package:la_bonne_franquette_front/views/caisse/paiement/widgets/article_paiement_item_widget.dart';
import 'package:la_bonne_franquette_front/services/provider/paiement_notifier.dart';

class CommandeSideWidget extends HookWidget {
  const CommandeSideWidget({super.key});

  @override
  Widget build(BuildContext context) {
    PaiementViewModel viewModel = PaiementViewModel();

    return Consumer<PaiementNotifier>(
      builder: (context, paiementNotifier, child) {
        return SizedBox(
          width: MediaQuery.of(context).size.width / 2 - 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(viewModel.title,
                  style: Theme.of(context).textTheme.headlineMedium),
              DateLivraisonChoiceWidget(),
              Padding(padding: EdgeInsets.symmetric(vertical: 12)),
              Expanded(
                child: paiementNotifier.currentArticles.isNotEmpty
                    ? ListView.builder(
                        itemCount: paiementNotifier.currentArticles.length,
                        itemBuilder: (context, index) {
                          final item = paiementNotifier.currentArticles[index];
                          final isSelected = paiementNotifier.currentSelection.contains(item);
                          final isPaid = paiementNotifier.isArticlePaiementPaidIndexed(item, index);
                          return ItemLineWidget(
                            item: item,
                            isSelected: isSelected,
                            isPaid: isPaid,
                          );
                        },
                      )
                    : SizedBox(),
              ),
            ],
          ),
        );
      },
    );
  }
}
