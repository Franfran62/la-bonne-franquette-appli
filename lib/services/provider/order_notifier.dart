import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article.dart';
import 'package:la_bonne_franquette_front/models/order.dart';
import 'package:la_bonne_franquette_front/models/enums/order_status.dart';
import 'package:la_bonne_franquette_front/models/wrapper/selection.dart';

class OrderNotifier extends ChangeNotifier {
  static final OrderNotifier _singleton = OrderNotifier._internal();

  static Order _currentOrder = Order(
      dineIn: true,
      articles: [],
      menus: [],
      payments: [],
      status: OrderStatus.EN_COURS,
      deliveryDate: DateTime.now(),
      paid: false);

  factory OrderNotifier() {
    return _singleton;
  }

  OrderNotifier._internal() {
    _currentOrder = Order(
      deliveryDate: DateTime.now(),
      dineIn: true,
      articles: [],
      menus: [],
      payments: [],
      status: OrderStatus.EN_COURS,
      paid: false,
    );
  }

  void reset() {
    _currentOrder = Order(
      deliveryDate: DateTime.now(),
      id: null,
      number: null,
      dineIn: true,
      articles: [],
      menus: [],
      payments: [],
      status: OrderStatus.EN_COURS,
      totalPrice: 0,
      paid: false,
    );
    defineTotalPrice();
  }

  Order get order {
    return _currentOrder;
  }

  set order(Order commande) {
    _currentOrder = commande;
    defineTotalPrice();
  }

  void addArticle(Article article) {
    if (_currentOrder.articles.contains(article)) {
      Article existingArticle =
          _currentOrder.articles.firstWhere((a) => a == article);
      existingArticle.quantity += 1;
    } else {
      _currentOrder.articles.add(article);
    }
    defineTotalPrice();
  }

  void addMenu(Selection menu) {
    if (_currentOrder.menus.contains(menu)) {
      Selection existingMenu = _currentOrder.menus.firstWhere((m) => m == menu);
      existingMenu.quantity += 1;
    } else {
      _currentOrder.menus.add(menu);
    }
    defineTotalPrice();
  }

  void removeArticle(Article article) {
    Article existingArticle =
        _currentOrder.articles.firstWhere((a) => a == article);
    if (existingArticle.quantity > 1) {
      existingArticle.quantity -= 1;
    } else {
      _currentOrder.articles.remove(article);
    }
    defineTotalPrice();
  }

  void removeMenu(Selection menu) {
    Selection existingMenu = _currentOrder.menus.firstWhere((m) => m == menu);
    if (existingMenu.quantity > 1) {
      existingMenu.quantity -= 1;
    } else {
      _currentOrder.menus.remove(menu);
    }
    defineTotalPrice();
  }

  void defineTotalPrice() {
    _currentOrder.totalPrice = _currentOrder.articles.fold(
        0,
        (previousValue, element) =>
            (previousValue ?? 0) + element.totalPrice * element.quantity);
    _currentOrder.totalPrice = (_currentOrder.totalPrice ?? 0) +
        _currentOrder.menus.fold(
            0,
            (previousValue, element) =>
                previousValue + element.totalPrice * element.quantity);
    notifyListeners();
  }

  void setDeliveryDate(DateTime date) {
    _currentOrder.deliveryDate = date;
    notifyListeners();
  }
}
