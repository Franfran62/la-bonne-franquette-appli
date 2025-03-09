import 'package:collection/collection.dart';
import 'package:la_bonne_franquette_front/models/wrapper/article.dart';
import 'package:la_bonne_franquette_front/models/enums/statusCommande.dart';
import 'package:la_bonne_franquette_front/models/paiement.dart';
import 'package:la_bonne_franquette_front/models/selection.dart';

class Commande {
  int? commandeId;
  int? numero;
  DateTime? dateSaisie;
  DateTime? dateLivraison;
  StatusCommande status;
  bool surPlace;
  int? nbArticle;
  int? prixTTC;
  List<Article> articles;
  List<Selection> menus;
  List<Paiement> paiementSet;
  String? paiementTypeCommande;

  Commande({
    this.commandeId,
    this.numero,
    this.dateSaisie,
    this.dateLivraison,
    required this.status,
    required this.surPlace,
    this.nbArticle,
    this.prixTTC,
    required List<Article>? articles,
    required List<Selection>? menus,
    required this.paiementSet,
    this.paiementTypeCommande,
  })  : articles = articles ?? [],
        menus = menus ?? [];

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
      dateLivraison: json['dateLivraison'] != null
          ? DateTime.parse(json['dateLivraison'])
          : null,
      status: StatusCommande.values.firstWhere(
          (status) => status.toString().split('.').last == json['status']),
      surPlace: json['surPlace'] ?? false,
      nbArticle: json['nbArticle'],
      prixTTC: json['prixTTC'],
      articles: articles,
      menus: menus,
      paiementSet: paiementSet,
      paiementTypeCommande: json['paiementTypeCommande'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> articlesJson =
        articles.map((article) => article.toJson()).toList();
    List<Map<String, dynamic>> menusJson =
        menus.map((selection) => selection.toJson()).toList();
    List<Map<String, dynamic>> paiementSetJson =
        paiementSet.map((paiement) => paiement.toJsonForCommande()).toList();

    return {
      'commandeId': commandeId,
      'numero': numero,
      'dateSaisie': dateSaisie?.toIso8601String(),
      'dateLivraison': dateLivraison?.toIso8601String(),
      'status': status.toString(),
      'surPlace': surPlace,
      'nbArticle': nbArticle,
      'prixTTC': prixTTC,

      'articles': articlesJson,
      'menus': menusJson,
      'paiementSet': paiementSetJson,
      'paiementTypeCommande': paiementTypeCommande,
    };
  }

  Map<String, dynamic> toCreateCommandeJson() {

    List<Map<String, dynamic>> articlesJson =
      articles.map((article) => article.toJson()).toList();
    List<Map<String, dynamic>> menusJson =
      menus.map((selection) => selection.toJson()).toList();
    List<Map<String, dynamic>> paiementSetJson =
      paiementSet.map((paiement) => paiement.toJsonForCommande()).toList();

    return {
      'status': StatusCommande.EN_COURS.name,
      'surPlace': surPlace,
      'prixTTC': prixTTC,
      'articles': articlesJson,
      'menus': menusJson,
      'paiementSet': paiementSetJson,
    };
  }

  int? getCommandeId() {
    return commandeId;
  }

  Article? findArticle(Article article) {
    return articles.firstWhereOrNull((a) {
      if (article.ingredients.isEmpty && article.extraSet.isEmpty) {
        return a.nom == article.nom &&
            (a.ingredients.isEmpty && a.extraSet.isEmpty);
      } else if (article.ingredients.isEmpty && article.extraSet.isNotEmpty) {
        return a.nom == article.nom &&
            a.extraSet == article.extraSet &&
            a.ingredients.isEmpty;
      } else if (article.ingredients.isNotEmpty && article.extraSet.isEmpty) {
        return a.nom == article.nom &&
            a.ingredients == article.ingredients &&
            a.extraSet.isEmpty;
      } else {
        return a.nom == article.nom &&
            a.ingredients == article.ingredients &&
            a.extraSet == article.extraSet;
      }
    });
  }

  List<Article> getArticlesConcatMenus() {
    List<Article> articlesConcatMenus = List.from(articles);
    for (var menu in menus) {
      for (var article in menu.articles) {
        var existingArticle = findArticle(article);
        if (existingArticle != null) {
          existingArticle.quantite += 1;
        } else {
          articlesConcatMenus.add(article);
        }
      }
    }
    return articlesConcatMenus;
  }

  @override
  String toString() {
    return 'Commande{commandeId: $commandeId, numero: $numero, dateSaisie: $dateSaisie, dateLivraison: $dateLivraison, status: $status, surPlace: $surPlace, nbArticle: $nbArticle, prixTTC: $prixTTC, articles: $articles, menus: $menus, paiementSet: $paiementSet, paiementTypeCommande: $paiementTypeCommande}';
  }
}
