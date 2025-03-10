import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/models/enums/PaymentChoice.dart';
import 'package:la_bonne_franquette_front/models/paiement.dart';
import 'package:la_bonne_franquette_front/models/selection.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article_paiement.dart';
import 'package:la_bonne_franquette_front/services/api/api_service.dart';
import 'package:la_bonne_franquette_front/services/provider/commande_notifier.dart';
import 'package:la_bonne_franquette_front/services/provider/paiement_notifier.dart';
import 'package:flutter/widgets.dart';

class CommandeViewModel extends ChangeNotifier {
  static final CommandeViewModel _singleton = CommandeViewModel._internal();
  
  String title = "";
  double number = 0;
  CommandeNotifier commandeNotifier = CommandeNotifier();
  PaiementNotifier paiementNotifier = PaiementNotifier();

  factory CommandeViewModel() {
    return _singleton;
  }
  CommandeViewModel._internal();

  void init(BuildContext context) {
    number = 0;
    paiementNotifier.currentArticles = ArticlePaiement.buildArticlePaiementList(
        commandeNotifier.currentCommande);
    paiementNotifier.currentPaid = ArticlePaiement.buildArticlePaiementPaid(
        commandeNotifier.currentCommande);
    paiementNotifier.total = commandeNotifier.currentCommande.prixTTC ?? 0;
    paiementNotifier.paiements = commandeNotifier.currentCommande.paiementSet;
    title = "Commande numéro ${commandeNotifier.currentCommande.numero}";
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
        body["articles"] = ArticlePaiement.getArticles(paiementNotifier.currentSelection);
        body["selections"] = ArticlePaiement.getSelections(paiementNotifier.currentSelection);
      break;
      case PaymentChoice.toutPayer:
        body["prix"] = paiementNotifier.resteAPayer;
        body["type"] = paiementNotifier.selectedPaymentType;
        body["articles"] = ArticlePaiement.getArticles(paiementNotifier.currentArticles);
        body["selections"] = ArticlePaiement.getSelections(paiementNotifier.currentArticles);
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

  Future<bool> sendEmail(String email, bool seeDetails) async {
    var body = {
      "email": email,
      "seeDetails": seeDetails,
      "commandeId": commandeNotifier.currentCommande.commandeId,
      "date": DateTime.now().toIso8601String(),
    };
    body.addAll(setPaymentInfo());

    var response = await ApiService.post(
        endpoint: "/api/v1/paiement/sendReceipt", body: body, token: true);

    return response.code == 200;
  }

  void valid(BuildContext context) {
    if (paiementNotifier.selectedPayment == PaymentChoice.toutPayer) {
      pay();
    }
    reset();
    GoRouter.of(context).go("/destinationCommande");
  }

  void pay() async {
    var body = setPaymentInfo();
    Paiement paiement = Paiement(
      type: paiementNotifier.selectedPaymentType!, 
      commandeId: commandeNotifier.currentCommande.commandeId!,
      prix: body["prix"],
      articles: body["articles"],
      selections: body["selections"],
    );
    var response = await ApiService.post(
        endpoint: "/paiement/${commandeNotifier.currentCommande.commandeId}", body: paiement.toSend(), token: true);
    paiement.id = response["id"];
    paiement.date = DateTime.parse(response["date"]);
    paiementNotifier.addPaiement(paiement);
    number = 0;
  }

  void rembourser() {
    paiementNotifier.currentMontant = paiementNotifier.resteAPayer;
  }

  Future<void> cancel(BuildContext context) async {
    await ApiService.delete(endpoint: '/commandes/${commandeNotifier.currentCommande.commandeId.toString()}');
    reset();
    GoRouter.of(context).go("/destinationCommande");
  }

  void reset() {
    number = 0;
    paiementNotifier.reset();
    commandeNotifier.reset();
  }
}
