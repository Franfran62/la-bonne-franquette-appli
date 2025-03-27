import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/models/commande.dart';
import 'package:la_bonne_franquette_front/models/enums/PaymentChoice.dart';
import 'package:la_bonne_franquette_front/models/paiement.dart';
import 'package:la_bonne_franquette_front/models/selection.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article_paiement.dart';
import 'package:la_bonne_franquette_front/services/api/api_service.dart';
import 'package:la_bonne_franquette_front/services/provider/commande_notifier.dart';
import 'package:la_bonne_franquette_front/services/provider/paiement_notifier.dart';
import 'package:flutter/widgets.dart';

class PaiementViewModel extends ChangeNotifier {
  static final PaiementViewModel _singleton = PaiementViewModel._internal();

  String title = "";
  double number = 0;
  Commande? commande;
  PaiementNotifier paiementNotifier = PaiementNotifier();

  factory PaiementViewModel() {
    return _singleton;
  }
  PaiementViewModel._internal();

  void init(BuildContext context, Commande newCommande) {
    commande = newCommande;
    number = 0;
    paiementNotifier.currentArticles = ArticlePaiement.buildArticlePaiementList(commande!);
    paiementNotifier.currentPaid = ArticlePaiement.buildArticlePaiementPaid(commande!);
    paiementNotifier.total = commande!.prixTTC ?? 0;
    paiementNotifier.paiements = commande!.paiementSet;
    title = "Commande numéro ${commande!.numero}";
    (context as Element).markNeedsBuild();
  }

  setPaymentInfo() {
    var body = {};
    switch (paiementNotifier.selectedPayment) {
      case PaymentChoice.montant:
        body["prix"] = paiementNotifier.currentMontant;
        body["type"] = paiementNotifier.selectedPaymentType;
        body["articles"] = <Article>[];
        body["selections"] = <Selection>[];
        break;
      case PaymentChoice.selection:
        body["prix"] = paiementNotifier.displayTotalSelection();
        body["type"] = paiementNotifier.selectedPaymentType;
        body["articles"] =
            ArticlePaiement.getArticles(paiementNotifier.currentSelection);
        body["selections"] =
            ArticlePaiement.getSelections(paiementNotifier.currentSelection);
        break;
      case PaymentChoice.toutPayer:
        body["prix"] = paiementNotifier.resteAPayer;
        body["type"] = paiementNotifier.selectedPaymentType;
        body["articles"] =
            ArticlePaiement.getArticles(paiementNotifier.currentArticles);
        body["selections"] =
            ArticlePaiement.getSelections(paiementNotifier.currentArticles);
        break;
      case PaymentChoice.rembourser:
        body["prix"] = paiementNotifier.currentMontant;
        body["type"] = paiementNotifier.selectedPaymentType;
        body["articles"] = <Article>[];
        body["selections"] = <Selection>[];
        break;
    }
    return body;
  }

  void valid(BuildContext context) {
    if (paiementNotifier.selectedPayment == PaymentChoice.toutPayer) {
      pay();
    }
    reset();
    context.pushNamed('caisse');
  }

  void pay() async {
    var body = setPaymentInfo();
    Paiement paiement = Paiement(
      type: paiementNotifier.selectedPaymentType!.name,
      prix: body["prix"],
      articles: body["articles"],
      selections: body["selections"],
    );
    var response = await ApiService.post(
        endpoint: "/paiement/${commande!.commandeId}",
        body: paiement.toSend(),
        token: true);
    paiement.id = response["id"];
    paiement.date = DateTime.parse(response["date"]);
    paiementNotifier.addPaiement(paiement);
    number = 0;
  }

  void rembourser() {
    paiementNotifier.currentMontant = paiementNotifier.resteAPayer;
  }

  Future<void> cancel(BuildContext context) async {
    await ApiService.delete(
        endpoint:
            '/commandes/${commande!.commandeId}');
    reset();
    context.pushNamed('caisse');
  }

  void reset() {
    number = 0;
    paiementNotifier.reset();
  }

  updateDateLivraison() {
    try {
      ApiService.patch(
          endpoint: "/commandes/${commande!.commandeId}",
          body: { 'dateLivraison': commande!.dateLivraison?.toIso8601String()},
          token: true);
    } catch (e) {
      print(e);
    }
  }
}
