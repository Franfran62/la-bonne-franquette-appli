import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_bonne_franquette_front/services/provider/commande_notifier.dart';
import 'package:la_bonne_franquette_front/views/commande/viewmodel/commande_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/views/commande/widgets/commande_side_widget.dart';
import 'package:la_bonne_franquette_front/views/commande/widgets/paiement_side_widget.dart';
import 'package:la_bonne_franquette_front/widgets/mainScaffold/main_scaffold.dart';
import 'package:la_bonne_franquette_front/views/caisse/prisecommande/widget/panier_widget.dart';
import 'package:provider/provider.dart';


class CommandePage extends HookWidget {

  CommandePage({super.key});
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final viewModel = CommandeViewModel();

  @override
  Widget build(BuildContext context) {

    viewModel.init();
        return MainScaffold(
          destination: "/cuisine",
          scaffoldKey: _scaffoldKey,
          body: Consumer<CommandeNotifier>(
          builder: (context, commandeNotifier, _) {
            final menus = commandeNotifier.currentCommande.menus;
            final articles = commandeNotifier.currentCommande.articles;
            final items = [...menus, ...articles];
            return Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: CommandeSideWidget(
                  items: items,
                  title: viewModel.title!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                children: [
                  PaiementSideWidget(
                    resteAPayer: viewModel.resteAPayer!,
                    selectionne: 0,
                    total: commandeNotifier.currentCommande.prixHT!,
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 80)),
                  Row(
                      children: [
                        ElevatedButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                          backgroundColor: null,
                          textStyle: GoogleFonts.notoSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        onPressed: () {
                          // TODO
                        },
                        child: Column(
                          children: [
                          Text('Annuler'),
                          Text('la commande'),
                          ],
                        ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                        ElevatedButton(
                            onPressed: () async {
                              await viewModel.sendOrder();
                              GoRouter.of(context).go("/destinationCommande");
                            },
                            child: Text('Valider'),
                          )
                      ],
                    ),
                ],
              ),
              ),
            ],
          );
        }
      )
    );
  }
}