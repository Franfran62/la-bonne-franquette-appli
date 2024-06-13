import 'package:la_bonne_franquette_front/models/commande.dart';

class Paiement {
  final int id;
  final DateTime date;
  final String type;
  final bool ticketEnvoye;
  final int prixHT;
  final int prixTTC;
  final Commande commande;

  Paiement({
    required this.id,
    required this.date,
    required this.type,
    required this.ticketEnvoye,
    required this.prixHT,
    required this.prixTTC,
    required this.commande,
  });

  factory Paiement.fromJson(Map<String, dynamic> json) {
    return Paiement(
      id: json['id'],
      date: DateTime.parse(json['date']),
      type: json['type'],
      ticketEnvoye: json['ticketEnvoye'],
      prixHT: json['prixHT'],
      prixTTC: json['prixTTC'],
      commande: Commande.fromJson(json['commande']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'type': type,
      'ticketEnvoye': ticketEnvoye,
      'prixHT': prixHT,
      'prixTTC': prixTTC,
      'commande': commande.toJson(),
    };
  }

    Map<String, dynamic> toJsonForCommande() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'type': type,
      'ticketEnvoye': ticketEnvoye,
      'prixHT': prixHT,
      'prixTTC': prixTTC,
    };
  }
}