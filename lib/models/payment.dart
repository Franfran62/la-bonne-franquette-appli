import 'package:la_bonne_franquette_front/models/wrapper/selection.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article.dart';
import 'package:la_bonne_franquette_front/models/payment_type.dart';

class Payment {
  int? id;
  DateTime? date;
  final String type;
  final List<Article> articles;
  final List<Selection> selections;
  final int price;

  Payment({
    required this.type,
    required this.price,
    this.id,
    this.date,
    this.articles = const [],
    this.selections = const [],
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      date: DateTime.parse(json['date']),
      type: json['type'],
      articles: json['articles']
          .map<Article>((article) => Article.fromJson(article))
          .toList(),
      selections: json['selections']
          .map<Selection>((selection) => Selection.fromJson(selection))
          .toList(),
      price: json['price'],
    );
  }

  Map<String, dynamic> send() {
    return {
      'articles': articles,
      'selections': selections,
      'type': type,
      'price': price,
    };
  }

  Map<String, dynamic> sendJson() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'type': type,
      'price': price,
    };
  }

  @override
  String toString() {
    return 'Paiement{id: $id, date: $date, type: $type, articles: $articles, selections: $selections, price: $price}';
  }
}
