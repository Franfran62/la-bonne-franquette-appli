import 'package:la_bonne_franquette_front/models/wrapper/article.dart';
import 'package:la_bonne_franquette_front/models/paiementTypeCommande.dart';

class Paiement {
  int? id;
  final DateTime? date;
  final PaiementTypeCommande type;
  final List<Article> articles;
  final int prix;
  final int commandeId;

  Paiement({
    required this.type,
    required this.prix,
    required this.commandeId,
    this.id,
    this.date,
    this.articles = const [],
  });

  factory Paiement.fromJson(Map<String, dynamic> json) {
    return Paiement(
      id: json['id'],
      date: DateTime.parse(json['date']),
      type: PaiementTypeCommande.fromJson(json['type']),
      articles: json['articles'].map<Article>((article) => Article.fromJson(article)).toList(),
      prix: json['prix'],
      commandeId: json['commandeId'],
    );
  }

    Map<String, dynamic> toSend() {
    return {
      'id': id,
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
}