import 'package:la_bonne_franquette_front/exceptions/request_exception.dart';
import 'package:la_bonne_franquette_front/models/order.dart';
import 'package:la_bonne_franquette_front/models/enums/payment_choice.dart';
import 'package:la_bonne_franquette_front/models/enums/order_status.dart';
import 'package:la_bonne_franquette_front/models/payment.dart';
import 'package:la_bonne_franquette_front/models/wrapper/selection.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article_payment.dart';
import 'package:la_bonne_franquette_front/services/api/api_request.dart';
import 'package:la_bonne_franquette_front/services/provider/payment_notifier.dart';
import 'package:flutter/widgets.dart';

class PaymentViewModel extends ChangeNotifier {
  static final PaymentViewModel _singleton = PaymentViewModel._internal();

  String title = "";
  double number = 0;
  Order? order;
  PaymentNotifier paymentNotifier = PaymentNotifier();

  factory PaymentViewModel() {
    return _singleton;
  }
  PaymentViewModel._internal();

  void init(BuildContext context, Order newOrder) {
    order = newOrder;
    number = 0;
    paymentNotifier.currentArticles = ArticlePayment.build(order!);
    paymentNotifier.currentPaid =
        ArticlePayment.buildArticlePaiementPaid(order!);
    paymentNotifier.total = order!.totalPrice ?? 0;
    paymentNotifier.payments = order!.payments;
    title = "Commande numéro ${order!.number}";
    (context as Element).markNeedsBuild();
  }

  setPaymentInfo() {
    var body = {};
    switch (paymentNotifier.selectedPayment) {
      case PaymentChoice.custom:
        body["price"] = paymentNotifier.price;
        body["type"] = paymentNotifier.selectedPaymentType;
        body["articles"] = <Article>[];
        body["selections"] = <Selection>[];
        break;
      case PaymentChoice.selected:
        body["price"] = paymentNotifier.defineSelected();
        body["type"] = paymentNotifier.selectedPaymentType;
        body["articles"] = ArticlePayment.getArticles(paymentNotifier.selected);
        body["selections"] =
            ArticlePayment.getSelections(paymentNotifier.selected);
        break;
      case PaymentChoice.full:
        body["price"] = paymentNotifier.amontDue;
        body["type"] = paymentNotifier.selectedPaymentType;
        body["articles"] = ArticlePayment.getArticles(paymentNotifier.articles);
        body["selections"] =
            ArticlePayment.getSelections(paymentNotifier.articles);
        break;
      case PaymentChoice.refund:
        body["price"] = paymentNotifier.price;
        body["type"] = paymentNotifier.selectedPaymentType;
        body["articles"] = <Article>[];
        body["selections"] = <Selection>[];
        break;
    }
    return body;
  }

  Future<void> valid() async {
    try {
      if (paymentNotifier.selectedPayment == PaymentChoice.full) {
        await pay();
      }
      reset();
    } on RequestException {
      rethrow;
    } catch (e) {
      throw Exception("Une erreur inattendue s'est produite.");
    }
  }

  Future<void> pay() async {
    try {
      var body = setPaymentInfo();
      Payment payment = Payment(
        type: paymentNotifier.selectedPaymentType!.name,
        price: body["price"],
        articles: body["articles"],
        selections: body["selections"],
      );
      var response = await ApiRequest.post(
          endpoint: "/payment/${order!.id}", body: payment.send(), token: true);
      payment.id = response["id"];
      payment.date = DateTime.parse(response["date"]);
      paymentNotifier.addPayment(payment);
      number = 0;
    } on RequestException {
      rethrow;
    } catch (e) {
      throw Exception("Une erreur inattendue s'est produite.");
    }
  }

  void refund() {
    paymentNotifier.currentPrice = paymentNotifier.amontDue;
  }

  Future<void> cancel() async {
    try {
      await ApiRequest.patch(
        endpoint: '/order/${order!.id}',
        body: {
          "status": OrderStatus.ANNULEE.name,
        },
        token: true,
      );
      reset();
    } on RequestException {
      rethrow;
    } catch (e) {
      throw Exception("Une erreur inattendue s'est produite.");
    }
  }

  void reset() {
    number = 0;
    paymentNotifier.reset();
  }

  updateDeliveryDate() {
    try {
      ApiRequest.patch(
          endpoint: "/order/${order!.id}",
          body: {'creationDate': order!.creationDate?.toIso8601String()},
          token: true);
    } on RequestException {
      rethrow;
    } catch (e) {
      throw Exception("Une erreur inattendue s'est produite.");
    }
  }
}
