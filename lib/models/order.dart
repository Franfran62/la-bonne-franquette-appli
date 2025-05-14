import 'package:collection/collection.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article.dart';
import 'package:la_bonne_franquette_front/models/enums/order_status.dart';
import 'package:la_bonne_franquette_front/models/payment.dart';
import 'package:la_bonne_franquette_front/models/wrapper/selection.dart';

class Order {
  int? id;
  int? number;
  DateTime? creationDate;
  DateTime? deliveryDate;
  OrderStatus status;
  bool dineIn;
  int? articleCount;
  int? totalPrice;
  List<Article> articles;
  List<Selection> menus;
  List<Payment> payments;
  String? paymentType;
  bool paid;

  Order(
      {this.id,
      this.number,
      this.creationDate,
      this.deliveryDate,
      required this.status,
      required this.dineIn,
      this.articleCount,
      this.totalPrice,
      required List<Article>? articles,
      required List<Selection>? menus,
      required this.payments,
      this.paymentType,
      required this.paid})
      : articles = articles ?? [],
        menus = menus ?? [];

  factory Order.fromJson(Map<String, dynamic> json) {
    List<Article> articles = [];
    if (json['articles'] != null) {
      json['articles'].forEach((articleJson) {
        articles.add(Article.fromJson(articleJson));
      });
    }

    List<Selection> menus = [];
    if (json['menus'] != null) {
      json['menus'].forEach((menuJson) {
        menus.add(Selection.fromJson(menuJson));
      });
    }

    List<Payment> payments = [];
    if (json['payments'] != null) {
      json['payments'].forEach((paiementJson) {
        payments.add(Payment.fromJson(paiementJson));
      });
    }

    return Order(
      id: json['id'],
      number: json['number'],
      creationDate: DateTime.parse(json['creationDate']).toLocal(),
      deliveryDate: DateTime.parse(json['deliveryDate']).toLocal(),
      status: OrderStatus.values.firstWhere(
          (status) => status.toString().split('.').last == json['status']),
      dineIn: json['dineIn'] ?? false,
      articleCount: json['articleCount'],
      totalPrice: json['totalPrice'],
      articles: articles,
      menus: menus,
      payments: payments,
      paid: json['paid'],
      paymentType: json['paymentType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> articlesJson =
        articles.map((article) => article.toJson()).toList();
    List<Map<String, dynamic>> menusJson =
        menus.map((selection) => selection.toJson()).toList();
    List<Map<String, dynamic>> paiementSetJson =
        payments.map((paiement) => paiement.sendJson()).toList();

    return {
      'id': id,
      'number': number,
      'creationDate': creationDate?.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'status': status.toString(),
      'dineIn': dineIn,
      'articleCount': articleCount,
      'totalPrice': totalPrice,
      'articles': articlesJson,
      'menus': menusJson,
      'payments': paiementSetJson,
      'paymentType': paymentType,
    };
  }

  Map<String, dynamic> toAPI({bool patch = false}) {
    List<Map<String, dynamic>> articlesJson =
        articles.map((article) => article.toJson()).toList();
    List<Map<String, dynamic>> menusJson =
        menus.map((selection) => selection.toJson()).toList();

    return patch
        ? {
            'dineIn': dineIn,
            'totalPrice': totalPrice,
            'articles': articlesJson,
            'menus': menusJson,
          }
        : {
            'status': status.name,
            'dineIn': dineIn,
            'totalPrice': totalPrice,
            'articles': articlesJson,
            'menus': menusJson,
            "creationDate": creationDate?.toIso8601String(),
            "deliveryDate": deliveryDate?.toIso8601String(),
          };
  }

  int? getId() {
    return id;
  }

  Article? findArticle(Article article) {
    return articles.firstWhereOrNull((a) {
      if (article.ingredients.isEmpty && article.addons.isEmpty) {
        return a.name == article.name &&
            (a.ingredients.isEmpty && a.addons.isEmpty);
      } else if (article.ingredients.isEmpty && article.addons.isNotEmpty) {
        return a.name == article.name &&
            a.addons == article.addons &&
            a.ingredients.isEmpty;
      } else if (article.ingredients.isNotEmpty && article.addons.isEmpty) {
        return a.name == article.name &&
            a.ingredients == article.ingredients &&
            a.addons.isEmpty;
      } else {
        return a.name == article.name &&
            a.ingredients == article.ingredients &&
            a.addons == article.addons;
      }
    });
  }

  List<Article> getArticlesConcatMenus() {
    List<Article> articlesConcatMenus = List.from(articles);
    for (var menu in menus) {
      for (var article in menu.articles) {
        var existingArticle = findArticle(article);
        if (existingArticle != null) {
          existingArticle.quantity += 1;
        } else {
          articlesConcatMenus.add(article);
        }
      }
    }
    return articlesConcatMenus;
  }

  @override
  String toString() {
    return 'Commande{id: $id, number: $number, creationDate: $creationDate, deliveryDate: $deliveryDate, status: $status, dineIn: $dineIn, articleCount: $articleCount, totalPrice: $totalPrice, articles: $articles, menus: $menus, payments: $payments, paymentType: $paymentType}';
  }
}
