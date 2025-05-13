import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/exception/api_exception.dart';
import 'package:la_bonne_franquette_front/models/enums/PaymentChoice.dart';
import 'package:la_bonne_franquette_front/services/provider/paiement_notifier.dart';
import 'package:la_bonne_franquette_front/services/utils/error_dialog_extension.dart';
import 'package:la_bonne_franquette_front/theme.dart';
import 'package:la_bonne_franquette_front/views/caisse/paiement/viewmodel/paiement_view_model.dart';
import 'package:la_bonne_franquette_front/views/caisse/paiement/widgets/valid_paiement_widget.dart';
import 'package:la_bonne_franquette_front/views/caisse/paiement/widgets/type_paiement_dropdown_widget.dart';
import 'package:la_bonne_franquette_front/views/caisse/paiement/widgets/type_paiement_widget.dart';
import 'package:provider/provider.dart';

class PaiementSideWidget extends HookWidget {
  const PaiementSideWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final PaiementViewModel viewModel = PaiementViewModel();
    final double width = MediaQuery.of(context).size.width / 2;
    const double choiceLabelPadding = 10.0;

    return Consumer<PaiementNotifier>(
      builder: (context, paiementNotifier, child) {
        return SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width / 2,
                      child: Text(
                        "Total :",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    Text(
                      "${paiementNotifier.total / 100} €",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width / 2,
                      child: Text(
                        "Reste à payer :",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    Text(
                      "${paiementNotifier.resteAPayer / 100} €",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              if (paiementNotifier.resteAPayer != 0)
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: TypePaiementWidget(),
                ),
              if (paiementNotifier.resteAPayer != 0)
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: TypePaiementDropDownWidget(),
                ),
              if (paiementNotifier.resteAPayer != 0)
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 12),
                  child: ValidPaimentWidget(
                    paymentChoiceState: paiementNotifier.selectedPayment,
                    resteAPayer: paiementNotifier.resteAPayer,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 40.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            try {
                              await viewModel.valid();
                              context.pushNamed('caisse');
                            } on ForbiddenException catch (e) {
                              context.showLogoutDialog(e.message);
                            } on ConnectionException catch (e) {
                              context.showLogoutDialog(e.message);
                            } on ApiException catch (e) {
                              context.showError(e.message);
                            } catch (e) {
                              context.showError(e.toString(), redirect: true, route: "login");
                            } 
                          },
                          child: Text('Valider')),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          try {
                            await viewModel.cancel();
                            context.pushNamed('caisse');

                          } on ForbiddenException catch (e) {
                            context.showLogoutDialog(e.message);
                          } on ConnectionException catch (e) {
                            context.showLogoutDialog(e.message);
                          } on ApiException catch (e) {
                            context.showError(e.message);
                          } catch (e) {
                            context.showError(e.toString(), redirect: true, route: "login");
                          }
                        },
                        style: CustomTheme.getCancelElevatedButtonTheme(Colors.white).style,
                        child: Text(
                          'Annuler',
                        )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
