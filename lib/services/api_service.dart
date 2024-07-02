import 'dart:convert';

import 'package:la_bonne_franquette_front/models/user.dart';
import 'package:la_bonne_franquette_front/stores/secured_storage.dart';

import '../api/utils_api.dart';
import 'package:http/http.dart' as http;

class ApiService{

  static final UtilsApi tool = UtilsApi();  

  //Websocket
  static String wsQueryString = "$baseUrl/ws";

  //api
  static String apiQueryString = "$baseUrl/api/v1";

  //login
  static String createUserQuery = "$apiQueryString/user/create";

  static String? baseUrl;

  static Future<String> getToken() async {
    String? authToken = await SecuredStorage().readSecret('auth-token');
    return authToken ?? "";
  }

  static Future<void> setBaseAddressServer() async {
    await SecuredStorage().readSecret('adresseServeur').then((value) => {
      baseUrl = 'http://$value'
    });
  }

  Future<Map<String, String>> setHeaders(bool token) async {
    if(token){
      String authToken = await getToken();
      return {
        'auth-token': authToken,
        'Content-Type': 'application/json'
      };
    }

    return {
      'Content-Type': 'application/json'
    };
  }

  /// Fonction permettant d'envoyer une requête GET à une ressource précisée en paramétre par 'endpoint'
  /// @param endpoint: String de la ressource à laquelle on veut accéder
  /// @param token: Booléen permettant de savoir si on posséde un token ou non, défaut à false
  /// @return Future<Map<String, dynamic>>: Map contenant les données de la ressource, avec comme clé le nom des champs de l'objet
  /// @throws Exception
  // TODO : utile ?
  Future<List<JsonCodec>> get({required String endpoint, bool token = false}) async{

    Map<String, String> headers = await setHeaders(token);
    final response = await http.get(Uri.parse(apiQueryString + endpoint), headers: headers);
    if(response.statusCode >= 300){
      throw Exception('Erreur : Impossible d\'accéder à la ressource : $endpoint, ${response.statusCode} : ${response.body}');
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<List<dynamic>> fetchAll({required String endpoint, bool token = false}) async{

    Map<String, String> headers = await setHeaders(token);
    final response = await http.get(Uri.parse(apiQueryString + endpoint), headers: headers);
    if(response.statusCode >= 300){
      throw Exception('Erreur : Impossible d\'accéder à la ressource : $endpoint, ${response.statusCode} : ${response.body}');
    } else {
      return jsonDecode(response.body);
    }
  }

  /// Fonction permettant d'envoyer une requête POST à une ressource précisée en paramétre par 'endpoint'
  /// @param endpoint: String de la ressource à laquelle on veut accéder
  /// @param body: Map contenant les données à envoyer
  /// @param token: Booléen permettant de savoir si on posséde un token ou non, défaut à false
  /// @return Future<Boolen>: retourne vrai si la requête a été effectuée, sinon léve une erreur
  /// @throws Exception
  Future<List<dynamic>> post({required String endpoint, required Map<dynamic, dynamic> body, bool token = false}) async{

    Map<String, String> headers = await setHeaders(token);
      final response = await http.post(Uri.parse(apiQueryString + endpoint), headers: headers, body: jsonEncode(body));
      if(response.statusCode >= 300){
      throw Exception('Erreur : Impossible d\'accéder à la ressource : $endpoint, ${response.statusCode} : ${response.body}');
      } else {
        return jsonDecode(response.body);
      }
    }

  /// Fonction permettant d'envoyer une requête PUT à une ressource précisée en paramétre par 'endpoint'  
  /// @param endpoint: String de la ressource à laquelle on veut accéder
  /// @param body: Map contenant les données à envoyer
  /// @param token: Booléen permettant de savoir si on posséde un token ou non, défaut à false
  /// @return Future<Boolen>: retourne vrai si la requête a été effectuée, sinon léve une erreur
  /// @throws Exception
  Future<List<dynamic>> put({required String endpoint, required Map<String, dynamic> body, bool token = false}) async{

    Map<String, String> headers = await setHeaders(token);
      final response = await http.put(Uri.parse(apiQueryString + endpoint), headers: headers, body: jsonEncode(body));
      if(response.statusCode >= 300){
      throw Exception('Erreur : Impossible d\'accéder à la ressource : $endpoint, ${response.statusCode} : ${response.body}');
      } else {
        return jsonDecode(response.body);
      }      
    }

  /// Fonction permettant de supprimer un obje
  /// @param endpoint: String de la ressource à supprimer
  /// @param token: Booléen permettant de savoir si on posséde un token ou non, défaut à false
  /// @return Future<Boolen>: retourne vrai si la suppression a été effectuée, sinon léve une erreur
  /// @throws Exception
  Future<bool> delete({required String endpoint, bool token = false}) async{
    Map<String, String> headers = await setHeaders(token);
    final response = await http.delete(Uri.parse(apiQueryString + endpoint), headers: headers);
    if(response.statusCode >= 300){
      throw Exception('Erreur : Impossible d\'accéder à la ressource : $endpoint, ${response.statusCode} : ${response.body}');
      } else {
        return true;
      }   
    }

  Future<bool> connect({required User user}) async {
    Map<String, String> headers = await setHeaders(false);
    final response = await http.post(Uri.parse('$apiQueryString/auth/login'), headers: headers, body: jsonEncode(user.toJson()));
    if(response.statusCode >= 300){
      throw Exception('Erreur : Impossible de se connecter, ${response.statusCode} : ${response.body}');
    } else {
      Map<String, dynamic> token = jsonDecode(response.body);
    SecuredStorage().writeSecrets("auth-token", token['token']);
    return true;
    }
  }

  Future<String> getCacheVersion() async {
    String token = await getToken();
    final response = await http.get(Uri.parse('$apiQueryString/version/cache'), headers: {
      'auth-token': token
    });
    if(response.statusCode >= 300){
      throw Exception('Erreur : Impossible de récupérer la version du cache, ${response.statusCode} : ${response.body}');
    } else {
      return response.body.toString();
    }    
  }

  Future<bool> testConnection(String serverAddress) async {
    final response = await http.get(Uri.parse("http://$serverAddress/api/v1/testConnection"));
    return response.statusCode == 200;
  }
}