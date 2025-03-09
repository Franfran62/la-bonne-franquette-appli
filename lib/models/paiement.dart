import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:la_bonne_franquette_front/models/paiementTypeCommande.dart';

class Paiement {
  int? id;
  final DateTime date;
  final PaiementTypeCommande type;
  final List<Article> articles;
  final int prixPaid;
  final int commandeId;

  Paiement({
    required this.date,
    required this.type,
    required this.prixPaid,
    required this.commandeId,
    this.id,
    this.articles = const [],
  });

  factory Paiement.fromJson(Map<String, dynamic> json) {
    return Paiement(
      id: json['id'],
      date: DateTime.parse(json['date']),
      type: PaiementTypeCommande.fromJson(json['type']),
      articles: json['articles'].map<Article>((article) => Article.fromJson(article)).toList(),
      prixPaid: json['prixPaid'],
      commandeId: json['commandeId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'type': type,
      'prixPaid': prixPaid,
      'commande': commandeId,
    };
  }

    Map<String, dynamic> toJsonForCommande() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'type': type,
      'prixPaid': prixPaid,
    };
  }
}