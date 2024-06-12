import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:la_bonne_franquette_front/models/articles.dart';
import 'package:la_bonne_franquette_front/models/produit.dart';
import 'package:la_bonne_franquette_front/services/api_service.dart';

class CaisseViewModel {
    final GetStorage carte = GetStorage('carte');
    late List<Produit> produits;

    CaisseViewModel() {
      produits = carte.read('produits') ?? [];
    }
  
    Future<void> addToCart(Produit produit) async {
      //TODO: ajouter extra
      List<Article> panier = carte.read('panier') ?? [];
      
      panier.where((e) => e.nom == produit.nom).forEach((e) => e.quantite += 1);
      if(panier.where((e) => e.nom == produit.nom).isEmpty) {
        panier.add(Article(nom: produit.nom, quantite: 1, prixHT: produit.prixHt, ingredients: [], extras: []));
      }
      carte.write('panier', panier);
    }

    Future<void> sendOrder() async{
      List<Article> articles = carte.read('panier') ?? [];
      int prixTotal = 0;
      for (var article in articles) {
        prixTotal += article.prixHT*article.quantite;
      }
      Map commandeBody = {
        "numero": 0,
        "surPlace": true,
        "menus": [],
        "paiementSet": [],
        "status": "EN_COURS",
        "articles": articles,
        "prixHT": prixTotal,
      };
      try {
        await ApiService().post(endpoint: 'commandes', body: commandeBody, token: true);
      } on Exception catch (e) {
        SnackBar(content: Text('Erreur lors de l\'envoi de la commande :\n$e'));
      }
      carte.write("panier", []);
    }
  
}