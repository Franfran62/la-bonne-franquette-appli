import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/enums/payment_choice.dart';
import 'package:la_bonne_franquette_front/models/payment.dart';
import 'package:la_bonne_franquette_front/models/payment_type.dart';
import 'package:la_bonne_franquette_front/models/wrapper/selection.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article_payment.dart';

class PaymentNotifier extends ChangeNotifier {
  static final PaymentNotifier _singleton = PaymentNotifier._internal();

  static List<ArticlePayment> _articles = [];
  static List<ArticlePayment> _paid = [];
  static List<ArticlePayment> _selected = [];
  static List<Payment> _payments = [];
  static int _amountDue = 0;
  static int _total = 0;

  int _price = 0;
  PaymentChoice _selectedPayment = PaymentChoice.full;
  PaymentType? _selectedPaymentType;

  factory PaymentNotifier() {
    return _singleton;
  }

  PaymentNotifier._internal() {
    _paid = [];
    _payments = [];
    _selected = [];
    _articles = [];
    _amountDue = 0;
    _total = 0;
  }

  void reset() {
    _paid = [];
    _payments = [];
    _selected = [];
    _articles = [];
    _amountDue = 0;
    _total = 0;
  }

  List<ArticlePayment> get paid {
    return _paid;
  }

  List<ArticlePayment> get selected {
    return _selected;
  }

  List<ArticlePayment> get articles {
    return _articles;
  }

  List<Payment> get payments {
    return _payments;
  }

  int get amontDue {
    return _amountDue;
  }

  int get total {
    return _total;
  }

  int get price => _price;

  PaymentChoice get selectedPayment => _selectedPayment;

  PaymentType? get selectedPaymentType => _selectedPaymentType;

  set total(int total) {
    _total = total;
    defineAmountDue();
  }

  set currentPaid(List<ArticlePayment> articlePaiements) {
    _paid = articlePaiements;
    notifyListeners();
  }

  set currentSelection(List<ArticlePayment> selection) {
    _selected = selection;
    notifyListeners();
  }

  set currentArticles(List<ArticlePayment> articles) {
    _articles = articles;
    notifyListeners();
  }

  set payments(List<Payment> payments) {
    _payments = payments;
    defineAmountDue();
  }

  set currentPrice(int value) {
    _price = value;
    notifyListeners();
  }

  set selectedPayment(PaymentChoice choice) {
    _selectedPayment = choice;
    _price = 0;
    _selected = [];
    notifyListeners();
  }

  set selectedPaymentType(PaymentType? type) {
    _selectedPaymentType = type;
    notifyListeners();
  }

  void defineAmountDue() {
    _amountDue = _total;
    for (var payment in _payments) {
      _amountDue -= payment.price;
    }
    if (_amountDue < 0) {
      _selectedPayment = PaymentChoice.refund;
    }
    notifyListeners();
  }

  int defineSelected() {
    int totalSelection = 0;
    for (var article in _selected) {
      totalSelection += article.article.totalPrice as int;
    }
    return totalSelection;
  }

  addSelection(ArticlePayment article) {
    _selected.add(article);
    notifyListeners();
  }

  removeSelection(ArticlePayment article) {
    _selected.remove(article);
    notifyListeners();
  }

  void addPayment(Payment payment) {
    _payments.add(payment);
    switch (selectedPayment) {
      case PaymentChoice.custom:
        break;
      case PaymentChoice.selected:
        _paid.addAll(selected);
        currentSelection = [];
        break;
      case PaymentChoice.full:
        for (var article in articles) {
          if (!_paid.contains(article)) {
            _paid.add(article);
          }
        }
        break;
      case PaymentChoice.refund:
        break;
    }
    defineAmountDue();
  }

  bool checkArticlePaymentPaidIndexed(ArticlePayment article, int index) {
    final sameBefore = _articles
        .sublist(0, index)
        .where((e) => _isSameArticlePayment(e, article))
        .length;

    final paidCount =
        _paid.where((e) => _isSameArticlePayment(e, article)).length;

    return sameBefore < paidCount;
  }

  bool _isSameArticlePayment(ArticlePayment a, ArticlePayment b) {
    if (a.article is Article && b.article is Article) {
      return a.article == b.article;
    }
    if (a.article is Selection && b.article is Selection) {
      return a.article == b.article;
    }
    return false;
  }
}
