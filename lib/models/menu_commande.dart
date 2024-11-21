import 'package:la_bonne_franquette_front/models/article.dart';

class MenuCommande {
  final String nom;
  final List<Article> articles;
  final int prixHT;
  int quantite;

  MenuCommande(
      {required this.nom, required this.quantite, required this.articles, required this.prixHT});

}
