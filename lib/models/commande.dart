import 'package:la_bonne_franquette_front/models/article.dart';
import 'package:la_bonne_franquette_front/models/enums/statusCommande.dart';
import 'package:la_bonne_franquette_front/models/paiement.dart';
import 'package:la_bonne_franquette_front/models/selection.dart';

class Commande {
  final int commandeId;
  final int numero;
  final DateTime dateSaisie;
  final DateTime? dateLivraison;
  final StatusCommande status;
  final bool surPlace;
  final int nbArticle;
  final int prixHT;
  final int tauxTVA;
  final List<Article> articles;
  final List<Selection> menus;
  final List<Paiement> paiementSet;
  final String? paiementTypeCommande;

  Commande({
    this.tauxTVA = 10,
    required this.commandeId,
    required this.numero,
    required this.dateSaisie,
    required this.dateLivraison,
    required this.status,
    required this.surPlace,
    required this.nbArticle,
    required this.prixHT,
    required this.articles,
    required this.menus,
    required this.paiementSet,
    required this.paiementTypeCommande,
  });

  factory Commande.fromJson(Map<String, dynamic> json) {
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

    List<Paiement> paiementSet = [];
    if (json['paiementSet'] != null) {
      json['paiementSet'].forEach((paiementJson) {
        paiementSet.add(Paiement.fromJson(paiementJson));
      });
    }

    return Commande(
      commandeId: json['commandeId'],
      numero: json['numero'],
      dateSaisie: DateTime.parse(json['dateSaisie']).toLocal(),
      dateLivraison: json['dateLivraison'] != null ? DateTime.parse(json['dateLivraison']) : null,
      status: StatusCommande.values.firstWhere(
        (status) => status.toString().split('.').last == json['status']),
      surPlace: json['surPlace'],
      nbArticle: json['nbArticle'],
      prixHT: json['prixHT'],
      tauxTVA: json['tauxTVA'],
      articles: articles,
      menus: menus,
      paiementSet: paiementSet,
      paiementTypeCommande: json['paiementTypeCommande'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> articlesJson = articles.map((article) => article.toJson()).toList();
    List<Map<String, dynamic>> menusJson = menus.map((selection) => selection.toJson()).toList();
    List<Map<String, dynamic>> paiementSetJson = paiementSet.map((paiement) => paiement.toJsonForCommande()).toList();

    return {
      'commandeId': commandeId,
      'numero': numero,
      'dateSaisie': dateSaisie.toIso8601String(),
      'dateLivraison': dateLivraison?.toIso8601String(),
      'status': status.toString(),
      'surPlace': surPlace,
      'nbArticle': nbArticle,
      'prixHT': prixHT,
      'tauxTVA': tauxTVA,
      'articles': articlesJson,
      'menus': menusJson,
      'paiementSet': paiementSetJson,
      'paiementTypeCommande': paiementTypeCommande,
    };
  }
  int getCommandeId() {
    return commandeId;
  }

}