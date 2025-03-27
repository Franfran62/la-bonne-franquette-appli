import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/models/enums/statusCommande.dart';
import 'package:provider/provider.dart';
import 'package:la_bonne_franquette_front/views/caisse/listedecommande/viewmodel/listedecommande_view_model.dart';

class CommandeListWidget extends StatelessWidget {
  const CommandeListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ListedeCommandeViewModel>(context);
    return FutureBuilder<void>(
      key: ValueKey(viewModel.getDate()),
      future: viewModel.refreshFromApi(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        } else {
          final commandes = viewModel.getCommandeList();
          if (commandes.isEmpty) {
            return const Center(child: Text('Aucune commande'));
          }
          return Expanded(
            child: Container(
              constraints: BoxConstraints(maxWidth: 1200),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildHeaderCell(context: context, text: 'Numéro'),
                      _buildHeaderCell(context: context, text: "Lieu"),
                      _buildHeaderCell(context: context, text: "Statut"),
                      _buildHeaderCell(context: context, text: "Saisie"),
                      _buildHeaderCell(context: context, text: "Livraison"),
                      _buildHeaderCell(context: context, text: "Prix"),
                      _buildHeaderCell(context: context, text: "Paiement"),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                    child: const Divider(height: 1, thickness: 1, indent: 80, endIndent: 80),
                  ),
                  Expanded(
                    child: ListView.builder(
                            itemCount: commandes.length,
                            itemBuilder: (context, index) {
                              final commande = commandes[index];
                              final isClickable =  commande.status != StatusCommande.ANNULEE && commande.status != StatusCommande.TERMINEE;
                              final child = Container(
                                   padding: const EdgeInsets.symmetric(vertical: 16),
                                   constraints: BoxConstraints(maxWidth: 1200),
                                   decoration: BoxDecoration(
                                    color: _buildRowColor(context: context, status: commande.status),
                                    borderRadius: BorderRadius.circular(8) 
                                   ),
                                   child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              _buildCell(context: context, text: commande.numero.toString()),
                                              _buildCell(context: context, text: commande.surPlace ? 'Sur place' : 'A emporter'),
                                              _buildCell(context: context, text: commande.status.name),
                                              _buildCell(context: context, text: "${commande.dateSaisie.hour}h${commande.dateSaisie.minute}"),
                                              _buildCell(context: context, text: "${commande.dateLivraison.hour}h${commande.dateLivraison.minute}"),
                                              _buildCell(context: context, text: "${commande.prixTTC / 100 } €"),
                                              _buildCell(context: context, text: commande.paiementType),
                                            ],
                                        )
                              );
                              return  Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: isClickable
                                      ? GestureDetector(
                                        onTap: () async => await viewModel.go(context, commande.commandeId), 
                                        child:  child)
                                      : child,
                              );
                            },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildHeaderCell({required BuildContext context, required String text, int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  Widget _buildCell({required BuildContext context, required String text, int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 1,
        ),
      ),
    );
  }

  Color _buildRowColor({required BuildContext context, required StatusCommande status}) {
    switch (status) {
      case StatusCommande.ANNULEE:
        return Colors.redAccent;
      case StatusCommande.TERMINEE:
        return Colors.greenAccent;
      default:
        return Theme.of(context).primaryColor;
    }
  }
}
