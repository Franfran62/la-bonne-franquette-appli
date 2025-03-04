
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/models/commande.dart';
import 'package:la_bonne_franquette_front/models/selection.dart';
import 'package:la_bonne_franquette_front/services/api/api_service.dart';
import 'package:la_bonne_franquette_front/services/provider/commande_notifier.dart';
import 'package:la_bonne_franquette_front/views/commande/viewmodel/commande_view_model.dart';
import 'package:la_bonne_franquette_front/widgets/panier/article_card.dart';
import 'package:la_bonne_franquette_front/widgets/panier/menu_card.dart';
import 'package:provider/provider.dart';

import '../../../models/article.dart';

class PanierWidget extends HookWidget {

  final double height;

  const PanierWidget({required this.height, super.key});

  @override
  Widget build(BuildContext context) {

    final CommandeViewModel viewModel = CommandeViewModel();
    return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 0, 0),
        child: Consumer<CommandeNotifier>(
          builder: (context, commandeNotifier, _) {
            final menus = commandeNotifier.currentCommande.menus;
            final articles = commandeNotifier.currentCommande.articles;
            final items = [...menus, ...articles];

            void sendCommand() async {
              if (commandeNotifier.currentCommande.commandeId != null) {
                await ApiService.patch(
                    endpoint: '/commandes/${commandeNotifier.currentCommande.commandeId}',
                    body: commandeNotifier.currentCommande.toJson(),
                    token: true);
              } else {
                  Map<String, dynamic> commande = await ApiService.post(
                    endpoint: '/commandes',
                    body: commandeNotifier.currentCommande.toCreateCommandeJson(),
                    token: true);
                  commandeNotifier.currentCommande.commandeId = commande['commandeId'];
                  commandeNotifier.currentCommande.numero = commande['numero'];
              }
            viewModel.init(context);
            context.push('/commande');
            }

            return Column(
              children: [
                items.isNotEmpty
                    ? SizedBox(
                        height: height - 150,
                        child: ListView(
                          children: items.map<Widget>((item) {
                            if (item is Selection) {
                              return Card(
                                color: item.isModified ? Color(0xFFE8F4FD) : Color(0xFFF8F9FA),
                                child: MenuCard(menu: item));
                            } else if (item is Article) {
                              return Card(
                                color: item.isModified ? Color(0xFFE8F4FD) : Color(0xFFF8F9FA),
                                child: ArticleCard(article: item));
                            } else {
                              return SizedBox.shrink();
                            }
                          }).toList(),
                        ),
                      )
                    : SizedBox(),
                items.isNotEmpty
                    ? Center(
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                onPressed: sendCommand,
                                child: Text(
                                  'Valider',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ),
                            Text(
                              'Total en cours : ${(commandeNotifier.currentCommande.prixHT! / 100).toStringAsFixed(2) ?? '0'} €',
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          ],
                        ),
                      )
                    : SizedBox(),
              ],
            );
          },
        ));
  }
}
