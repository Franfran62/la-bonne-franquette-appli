import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/exception/api_exception.dart';
import 'package:la_bonne_franquette_front/models/commande.dart';
import 'package:la_bonne_franquette_front/models/projection/commandeListProjection.dart';
import 'package:la_bonne_franquette_front/services/api/api_service.dart';
import 'package:la_bonne_franquette_front/views/caisse/paiement/viewmodel/paiement_view_model.dart';

class ListedeCommandeViewModel extends ChangeNotifier {
  ListedeCommandeViewModel._internal();

  static final ListedeCommandeViewModel _instance =
      ListedeCommandeViewModel._internal();

  factory ListedeCommandeViewModel() {
    return _instance;
  }

  List<CommandeListProjection> _commandeList = [];
  DateTime _date = DateTime.now();
  PaiementViewModel paiementViewModel = PaiementViewModel();

  List<CommandeListProjection> getCommandeList() {
    return _commandeList;
  }

  DateTime getDate() {
    return _date;
  }

  void init() {
    _date = DateTime.now();
  }

  void setDate(DateTime date) async {
    _date = date;
    notifyListeners();
  }

  Future<void> refreshFromApi() async {
    try {
      var response = await ApiService.get(
          endpoint: "/commandes/liste/${_date.year}-${_date.month}-${_date.day}",
          token: true);
      _commandeList = (response as List)
          .map((proj) => CommandeListProjection.fromJson(proj))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw Exception("Une erreur inattendue s'est produite.");
    }
  }

  Future<void> go(BuildContext context, int id) async {
    try {
      final commande = await ApiService.get(endpoint: "/commandes/${id}", token: true);
      paiementViewModel.init(context, Commande.fromJson(commande));
      context.pushNamed("caisse_paiement");
    } on ApiException {
      rethrow;
    } catch (e) {
      throw Exception("Une erreur inattendue s'est produite.");
    }
  }
}
