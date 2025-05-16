import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/models/wrapper/selection.dart';
import 'package:la_bonne_franquette_front/services/provider/order_notifier.dart';
import 'package:la_bonne_franquette_front/services/utils/error_dialog_extension.dart';
import 'package:la_bonne_franquette_front/views/cashier/payment/payment_viewmodel.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_entry/order_entry_viewmodel.dart';
import 'package:la_bonne_franquette_front/widgets/cart/card_article.dart';
import 'package:la_bonne_franquette_front/widgets/cart/card_menu.dart';
import 'package:provider/provider.dart';
import '../../../../exceptions/request_exception.dart';
import '../../../../models/wrapper/article.dart';

class CartWidget extends HookWidget {
  final double height;

  const CartWidget({required this.height, super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentViewModel paymentViewModel = PaymentViewModel();
    final OrderEntryViewModel orderEntryViewModel = OrderEntryViewModel();

    return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 0, 0),
        child: Consumer<OrderNotifier>(
          builder: (context, orderNotifier, _) {
            final menus = orderNotifier.order.menus;
            final articles = orderNotifier.order.articles;
            final items = [...menus, ...articles];

            void sendCommand() async {
              try {
                await orderEntryViewModel.createOrder();
                paymentViewModel.init(context, orderNotifier.order);
                context.goNamed('caisse_paiement');
              } on ForbiddenException catch (e) {
                context.showLogoutDialog(e.message);
              } on ConnectionException catch (e) {
                context.showLogoutDialog(e.message);
              } on RequestException catch (e) {
                context.showError(e.message);
              } catch (e) {
                context.showError("Une erreur inattendue s'est produite.",
                    redirect: true, route: "login");
              }
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
                                  color: item.modified
                                      ? Color(0xFFE8F4FD)
                                      : Color(0xFFF8F9FA),
                                  child: CardMenu(menu: item));
                            } else if (item is Article) {
                              return Card(
                                  color: item.modified
                                      ? Color(0xFFE8F4FD)
                                      : Color(0xFFF8F9FA),
                                  child: CardArticle(article: item));
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
                              'Total en cours : ${(orderNotifier.order.totalPrice! / 100).toStringAsFixed(2) ?? '0'} €',
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
