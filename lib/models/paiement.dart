import 'package:la_bonne_franquette_front/models/selection.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article.dart';
import 'package:la_bonne_franquette_front/models/paiementTypeCommande.dart';

class Paiement {
  int? id;
  DateTime? date;
  final String type;
  final List<Article> articles;
  final List<Selection> selections;
  final int prix;

  Paiement({
    required this.type,
    required this.prix,
    this.id,
    this.date,
    this.articles = const [],
    this.selections = const [],
  });

  factory Paiement.fromJson(Map<String, dynamic> json) {

    return Paiement(
      id: json['id'],
      date: DateTime.parse(json['date']),
      type: json['type'],
      articles: json['articles'].map<Article>((article) => Article.fromJson(article)).toList(),
      selections: json['selections'].map<Selection>((selection) => Selection.fromJson(selection)).toList(),
      prix: json['prix'],
    );
  }

    Map<String, dynamic> toSend() {
    return {
      'articles': articles,
      'selections': selections,
      'type': type,
      'prix': prix,
    };
  }

    Map<String, dynamic> toJsonForCommande() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'type': type,
      'prix': prix,
    };
  }

  @override
  String toString() {
    return 'Paiement{id: $id, date: $date, type: $type, articles: $articles, selections: $selections, prix: $prix}';
  }
}