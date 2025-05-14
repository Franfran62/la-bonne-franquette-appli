import 'dart:async';
import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/exceptions/request_exception.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article.dart';
import 'package:la_bonne_franquette_front/models/addon.dart';
import 'package:la_bonne_franquette_front/models/ingredient.dart';
import 'package:la_bonne_franquette_front/models/menu.dart';
import 'package:la_bonne_franquette_front/models/product.dart';
import 'package:la_bonne_franquette_front/models/wrapper/selection.dart';
import 'package:la_bonne_franquette_front/services/api/api_request.dart';
import 'package:la_bonne_franquette_front/services/provider/order_notifier.dart';
import 'package:la_bonne_franquette_front/services/stores/database_request.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_entry/widget/modification_modal.dart';
import '../../../models/category.dart';

class OrderEntryViewModel {
  static final OrderEntryViewModel _singleton = OrderEntryViewModel._internal();
  BuildContext? context;
  bool show = false;
  Selection menuSelected = Selection(
      name: "", articles: [], quantity: 1, totalPrice: 0, modified: false);
  OrderNotifier orderNotifier = OrderNotifier();

  factory OrderEntryViewModel() {
    return _singleton;
  }

  OrderEntryViewModel._internal();

  void init(bool dineIn) {
    orderNotifier.reset();
    orderNotifier.order.dineIn = dineIn;
    show = false;
    menuSelected = Selection(
        name: "", articles: [], quantity: 1, totalPrice: 0, modified: false);
  }

  bool getDineIn() {
    return orderNotifier.order.dineIn;
  }

  bool updateDineIn() {
    return orderNotifier.order.dineIn = !orderNotifier.order.dineIn;
  }

  Future<List<Menu>?> getMenus() async {
    return await DatabaseRequest.findAllMenus();
  }

  Future<List<Category>?> getCategories() async {
    return await DatabaseRequest.findAllCategories();
  }

  void updateShow() {
    show = !show;
  }

  Future<void> addProductToCart(Product product) async {
    Map<String, List> modifications = {
      "ingredients": <Ingredient>[],
      "addons": <Addon>[]
    };

    if (show) {
      modifications = await showEditModal(product);
    }

    Article article = Article(
      name: product.name,
      quantity: 1,
      totalPrice: product.totalPrice,
      ingredients: modifications["ingredients"] as List<Ingredient>,
      addons: modifications["addons"] as List<Addon>,
    );
    article.modified =
        (article.addons.isNotEmpty || article.ingredients.isNotEmpty)
            ? true
            : false;

    orderNotifier.addArticle(article);
    show = false;
  }

  void initMenuSelected({String name = ""}) {
    menuSelected.articles = [];
    menuSelected.name = name;
    menuSelected.quantity = 1;
    menuSelected.totalPrice = 0;
    menuSelected.modified = false;
  }

  Future<void> addToMenuSelected(Product product) async {
    Map<String, List> modifications = {
      "ingredients": <Ingredient>[],
      "addons": <Addon>[]
    };
    if (show) {
      modifications = await showEditModal(product);
    }
    Article article = Article(
        name: product.name,
        quantity: 1,
        totalPrice: product.totalPrice,
        ingredients: modifications["ingredients"] as List<Ingredient>,
        addons: modifications["addons"] as List<Addon>);
    article.modified =
        (article.addons.isNotEmpty || article.ingredients.isNotEmpty)
            ? true
            : false;

    menuSelected.addArticle(article);
    show = false;
  }

  void removeFromMenuSelected(int index) {
    menuSelected.removeArticleByIndex(index);
  }

  void addMenuToCart() async {
    Selection nouveauMenu = Selection(
        name: menuSelected.name,
        articles: List.from(menuSelected.articles),
        quantity: menuSelected.quantity,
        totalPrice: menuSelected.totalPrice,
        modified: menuSelected.modified);
    orderNotifier.addMenu(nouveauMenu);
    initMenuSelected();
  }

  Future<Map<String, List>> showEditModal(Product product) async {
    Completer<Map<String, List>> modification = Completer();
    showDialog(
      context: context as BuildContext,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.2,
            horizontal: MediaQuery.of(context).size.width * 0.2,
          ),
          child: ModificationModal(
            product: product,
            onModificationsSelected: (modifications) {
              modification.complete(modifications);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
    return modification.future;
  }

  Future<void> createOrder() async {
    try {
      if (orderNotifier.order.id != null) {
        await ApiRequest.patch(
            endpoint: '/order/${orderNotifier.order.id}',
            body: orderNotifier.order.toAPI(patch: true),
            token: true);
      } else {
        orderNotifier.order.creationDate = DateTime.now();
        orderNotifier.order.deliveryDate = DateTime.now();
        Map<String, dynamic> commande = await ApiRequest.post(
            endpoint: '/order',
            body: orderNotifier.order.toAPI(patch: false),
            token: true);
        orderNotifier.order.id = commande['id'];
        orderNotifier.order.number = commande['numero'];
        orderNotifier.order.creationDate =
            DateTime.parse(commande['creationDate']);
      }
    } on RequestException catch (e) {
      rethrow;
    } catch (e) {
      throw Exception("Une erreur inattendue s'est produite");
    }
  }
}
