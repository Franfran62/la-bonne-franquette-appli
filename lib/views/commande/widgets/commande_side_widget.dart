import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article_paiement.dart';
import 'package:la_bonne_franquette_front/views/commande/viewmodel/commande_view_model.dart';
import 'package:la_bonne_franquette_front/views/commande/widgets/article_paiement_item_widget.dart';
import 'package:la_bonne_franquette_front/services/provider/paiement_notifier.dart';

class CommandeSideWidget extends HookWidget {
  const CommandeSideWidget({super.key});

  @override
  Widget build(BuildContext context) {
    CommandeViewModel viewModel = CommandeViewModel();

    return Consumer<PaiementNotifier>(
      builder: (context, paiementNotifier, child) {

        return SizedBox(
          width: MediaQuery.of(context).size.width / 2 - 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(viewModel.title,
                  style: Theme.of(context).textTheme.headlineMedium),
              Padding(padding: EdgeInsets.symmetric(vertical: 20)),
              Expanded(
                child: paiementNotifier.currentArticles.isNotEmpty
                    ? ListView(
                        children: paiementNotifier.currentArticles.map<Widget>((item) {
                          return ItemLineWidget(
                            item: item,
                            isSelected: paiementNotifier.currentSelection.contains(item),
                          );
                        }).toList(),
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
