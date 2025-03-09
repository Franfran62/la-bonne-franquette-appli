import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/enums/PaymentChoice.dart';
import 'package:la_bonne_franquette_front/models/paiement.dart';
import 'package:la_bonne_franquette_front/models/paiementTypeCommande.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article_paiement.dart';
import 'package:la_bonne_franquette_front/services/stores/database_service.dart';

class PaiementNotifier extends ChangeNotifier {
  static final PaiementNotifier _singleton = PaiementNotifier._internal();

  static List<ArticlePaiement> _currentArticles = [];
  static List<ArticlePaiement> _currentPaid = [];
  static List<ArticlePaiement> _currentSelection = [];

  static List<Paiement> _paiements = [];

  static int _resteAPayer = 0;
  static int _total = 0;

  int _currentMontant = 0;
  PaymentChoice _selectedPayment = PaymentChoice.toutPayer;

  PaiementTypeCommande? _selectedPaymentType;

  factory PaiementNotifier() {
    return _singleton;
  }

  PaiementNotifier._internal() {
    _currentPaid = [];
    _currentSelection = [];
    _currentArticles = [];
    _resteAPayer = 0;
    _total = 0;
  }

  void reset() {
    _currentPaid = [];
    _currentSelection = [];
    _currentArticles = [];
    _resteAPayer = 0;
    _total = 0;
  }

  List<ArticlePaiement> get currentPaid {
    return _currentPaid;
  }

  List<ArticlePaiement> get currentSelection {
    return _currentSelection;
  }

  List<ArticlePaiement> get currentArticles {
    return _currentArticles;
  }

  List<Paiement> get paiements {
    return _paiements;
  }

  int get resteAPayer {
    return _resteAPayer;
  }

  int get total {
    return _total;
  }

  int get currentMontant => _currentMontant;

  PaymentChoice get selectedPayment => _selectedPayment;

  PaiementTypeCommande? get selectedPaymentType => _selectedPaymentType;

  set total(int total) {
    _total = total;
    updateResteAPayer();
  }

  set currentPaid(List<ArticlePaiement> articlePaiements) {
    _currentPaid = articlePaiements;
    notifyListeners();
  }

  set currentSelection(List<ArticlePaiement> selection) {
    _currentSelection = selection;
    notifyListeners();
  }

  set currentArticles(List<ArticlePaiement> articles) {
    _currentArticles = articles;
    notifyListeners();
  }

  set paiements(List<Paiement> paiements) {
    _paiements = paiements;
    updateResteAPayer();
  }

  set currentMontant(int value) {
    _currentMontant = value;
    notifyListeners();
  }

  set selectedPayment(PaymentChoice choice) {
    _selectedPayment = choice;
    _currentMontant = 0;
    _currentSelection = [];
    notifyListeners();
  }

  set selectedPaymentType(PaiementTypeCommande? type) {
    _selectedPaymentType = type;
    notifyListeners();
  }

  void updateResteAPayer() {
    _resteAPayer = total;
    for (var paiement in _paiements) {
      _resteAPayer -= paiement.prixPaid;
    }
    notifyListeners();
  }

  int displayTotalSelection() {
    int totalSelection = 0;
    for (var article in _currentSelection) {
      totalSelection += article.article.prixHT as int;
    }
    return totalSelection;
  }

  addSelection(ArticlePaiement article) {
    _currentSelection.add(article);
    notifyListeners();
  }

  removeSelection(ArticlePaiement article) {
    _currentSelection.remove(article);
    notifyListeners();
  }
}
