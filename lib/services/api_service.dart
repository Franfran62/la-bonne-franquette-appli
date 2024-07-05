import 'dart:convert';

import 'package:la_bonne_franquette_front/models/user.dart';
import 'package:la_bonne_franquette_front/stores/secured_storage.dart';

import '../api/utils_api.dart';
import 'package:http/http.dart' as http;

class ApiService{

  static final UtilsApi tool = UtilsApi();  

  //Websocket
  static String wsQueryString = "";
  //api
  static String apiQueryString = "";


  static Future<String> getToken() async {
    String? authToken = await SecuredStorage().readSecret('auth-token');
    return authToken ?? "";
  }

  static Future<void> setBaseAddressServer() async {
    await SecuredStorage().readSecret('adresseServeur').then((value) => {
      apiQueryString = 'http://$value/api/v1',
      wsQueryString = 'ws://$value/ws'
    });
  }

  static Future<Map<String, String>> setHeaders(bool token) async {
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

  static Future<List<JsonCodec>> get({required String endpoint, bool token = false}) async{

    Map<String, String> headers = await setHeaders(token);
    final response = await http.get(Uri.parse(apiQueryString + endpoint), headers: headers);
    if(response.statusCode >= 300){
      throw Exception('Erreur : Impossible d\'accéder à la ressource : $endpoint, ${response.statusCode} : ${response.body}');
    } else {
      return jsonDecode(response.body);
    }
  }

  static Future<List<dynamic>> fetchAll({required String endpoint, bool token = false}) async{

    Map<String, String> headers = await setHeaders(token);
    final response = await http.get(Uri.parse(apiQueryString + endpoint), headers: headers);
    if(response.statusCode >= 300){
      throw Exception('Erreur : Impossible d\'accéder à la ressource : $endpoint, ${response.statusCode} : ${response.body}');
    } else {
      return jsonDecode(response.body);
    }
  }
  
  static Future<List<dynamic>> post({required String endpoint, required Map<dynamic, dynamic> body, bool token = false}) async{

    Map<String, String> headers = await setHeaders(token);
      final response = await http.post(Uri.parse(apiQueryString + endpoint), headers: headers, body: jsonEncode(body));
      if(response.statusCode >= 300){
      throw Exception('Erreur : Impossible d\'accéder à la ressource : $endpoint, ${response.statusCode} : ${response.body}');
      } else {
        return jsonDecode(response.body);
      }
    }

  static Future<List<dynamic>> put({required String endpoint, required Map<String, dynamic> body, bool token = false}) async{

    Map<String, String> headers = await setHeaders(token);
      final response = await http.put(Uri.parse(apiQueryString + endpoint), headers: headers, body: jsonEncode(body));
      if(response.statusCode >= 300){
      throw Exception('Erreur : Impossible d\'accéder à la ressource : $endpoint, ${response.statusCode} : ${response.body}');
      } else {
        return jsonDecode(response.body);
      }      
    }

  static Future<bool> delete({required String endpoint, bool token = false}) async{
    Map<String, String> headers = await setHeaders(token);
    final response = await http.delete(Uri.parse(apiQueryString + endpoint), headers: headers);
    if(response.statusCode >= 300){
      throw Exception('Erreur : Impossible d\'accéder à la ressource : $endpoint, ${response.statusCode} : ${response.body}');
      } else {
        return true;
      }   
    }

  static Future<bool> connect({required User user}) async {
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

  static Future<String> getCacheVersion() async {
    String token = await getToken();
    final response = await http.get(Uri.parse('$apiQueryString/cache/version'), headers: {
      'auth-token': token
    });
    if(response.statusCode >= 300){
      throw Exception('Erreur : Impossible de récupérer la version du cache, ${response.statusCode} : ${response.body}');
    } else {
      return response.body.toString();
    }    
  }

  static Future<bool> testConnection({String adresse = ""}) async {
    var response;
    if (adresse == "") {
      String serverAddress = await SecuredStorage().readSecret("adresseServeur") as String;
      response = await http.get(Uri.parse("http://$serverAddress/api/v1/testConnection"));
    } else {
      response = await http.get(Uri.parse("http://$adresse/api/v1/testConnection"));
    }

    if (response.statusCode == 200) {
      await ApiService.setBaseAddressServer();
      return true;
    } else {
      throw Exception("Impossible de se connecter au serveur car l'adresse n'est pas configurer ou le serveur est injoignable");
    }
  } 
}