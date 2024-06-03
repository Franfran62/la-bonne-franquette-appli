import 'dart:convert';

import '../api/UtilsApi.dart';
import 'package:http/http.dart' as http;

class ApiService{

  static final UtilsApi tool = UtilsApi();

  // TODO: modifier pour accéder au token enregistrer après la connexion
  String authToken = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyIiwidXNlcm5hbWUiOiJ0ZXN0IiwiZXhwIjoxNzE3MzQzNjMyfQ.JgphTBNjKrBsF7s7c14H51MBL8_t-VQ2lWymkE21RyS9OL8ytSLPUyMsXEQQRfjrKfYs_lrxx7sDMSNRXyTl-g";

  final String baseQuery = UtilsApi.apiQueryString; 

  /// Fonction permettant d'envoyer une requête GET à une ressource précisée en paramétre par 'endpoint'
  /// @param endpoint: String de la ressource à laquelle on veut accéder
  /// @param token: Booléen permettant de savoir si on posséde un token ou non, défaut à false
  /// @return Future<Map<String, dynamic>>: Map contenant les données de la ressource, avec comme clé le nom des champs de l'objet
  /// @throws Exception
  Future<Map<String, dynamic>> get({required String endpoint, bool token = false}) async{

    if(token){
      final response = await http.get(Uri.parse(baseQuery + endpoint), headers: {
        'auth-token': authToken
      });
      if(response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur : Impossible d\'accéder à la ressource : $this.apiQueryString$endpoint');
      }
    }else{
      throw Exception('Erreur : Impossible d\'accéder à la ressource : $this.apiQueryString$endpoint.\n Token invalide.');
    }
  }

  /// Fonction permettant de supprimer un obje
  /// @param endpoint: String de la ressource à supprimer
  /// @param token: Booléen permettant de savoir si on posséde un token ou non, défaut à false
  /// @return Future<Boolen>: retourne vrai si la suppression a été effectuée, sinon léve une erreur
  /// @throws Exception
  Future<bool> delete({required String endpoint, bool token = false}) async{

    if(token){
      final response = await http.delete(Uri.parse(baseQuery + endpoint), headers: {
        'auth-token': authToken
      });
      if(response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Erreur : Impossible d\'accéder à la ressource : $this.apiQueryString$endpoint');
      }
    }else{
      throw Exception('Erreur : Impossible d\'accéder à la ressource : $this.apiQueryString$endpoint.\n Token invalide.');
    }
  }
}