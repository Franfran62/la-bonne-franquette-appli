import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:la_bonne_franquette_front/exceptions/request_exception.dart';
import 'package:la_bonne_franquette_front/models/enums/order_status.dart';
import 'package:la_bonne_franquette_front/services/utils/error_dialog_extension.dart';
import 'package:la_bonne_franquette_front/services/utils/time_formatter.dart';
import 'package:provider/provider.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_list/order_list_viewmodel.dart';

class OrderListWidget extends StatelessWidget {
  const OrderListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OrderListViewModel>(context);
    return FutureBuilder<void>(
      key: ValueKey(viewModel.getDate()),
      future: viewModel.refresh(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          if (snapshot.error is ForbiddenException) {
            context.showLogoutDialog(snapshot.error.toString());
          } else {
            context.showError("${snapshot.error}");
          }
          return const Center();
        } else {
          final commandes = viewModel.getOrderList();
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
                    child: const Divider(
                        height: 1, thickness: 1, indent: 80, endIndent: 80),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: commandes.length,
                      itemBuilder: (context, index) {
                        final commande = commandes[index];
                        final isClickable =
                            commande.status != OrderStatus.ANNULEE &&
                                commande.status != OrderStatus.TERMINEE;
                        final child = Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            constraints: BoxConstraints(maxWidth: 1200),
                            decoration: BoxDecoration(
                                color: _buildRowColor(
                                    context: context, status: commande.status),
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildCell(
                                    context: context,
                                    text: commande.number.toString()),
                                _buildCell(
                                    context: context,
                                    text: commande.dineIn
                                        ? 'Sur place'
                                        : 'A emporter'),
                                _buildCell(
                                    context: context,
                                    text: commande.status.name),
                                _buildCell(
                                    context: context,
                                    text: TimeFormatter.withSeparator(
                                        commande.creationDate)),
                                _buildCell(
                                    context: context,
                                    text: TimeFormatter.withSeparator(
                                        commande.deliveryDate)),
                                _buildCell(
                                    context: context,
                                    text: "${commande.totalPrice / 100} €"),
                                _buildCell(
                                    context: context,
                                    text: commande.paymentType),
                              ],
                            ));
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: isClickable
                              ? GestureDetector(
                                  onTap: () async =>
                                      await viewModel.go(context, commande.id),
                                  child: child)
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

  Widget _buildHeaderCell(
      {required BuildContext context, required String text, int flex = 1}) {
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

  Widget _buildCell(
      {required BuildContext context, required String text, int flex = 1}) {
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

  Color _buildRowColor(
      {required BuildContext context, required OrderStatus status}) {
    switch (status) {
      case OrderStatus.ANNULEE:
        return Colors.redAccent;
      case OrderStatus.TERMINEE:
        return Colors.greenAccent;
      default:
        return Theme.of(context).primaryColor;
    }
  }
}
