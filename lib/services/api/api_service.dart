import 'dart:convert';

import 'package:la_bonne_franquette_front/services/api/api_utils_service.dart';

import '../../api/utils_api.dart';
import 'package:http/http.dart' as http;

class ApiService{

  static final UtilsApi tool = UtilsApi();  
  static String apiQueryString = "";

  static Future<Map<String, String>> setHeaders(bool token) async {
    if(token){
      String authToken = await ApiUtilsService.getToken();
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

    static Future<Map<String, dynamic>> postCommande({required String endpoint, required Map<dynamic, dynamic> body, bool token = false}) async{

      Map<String, String> headers = await setHeaders(token);
      final response = await http.post(Uri.parse(apiQueryString + endpoint), headers: headers, body: jsonEncode(body));
      if(response.statusCode >= 300){
        throw Exception('Erreur : Impossible d\'accéder à la ressource : $endpoint, ${response.statusCode} : ${response.body}');
      } else {
        return jsonDecode(response.body);
      }
    }

  static Future<Map<String, dynamic>> put({required String endpoint, required Map<String, dynamic> body, bool token = false}) async{

    Map<String, String> headers = await setHeaders(token);
    var response;
      if(body.isNotEmpty){
        response = await http.put(Uri.parse(apiQueryString + endpoint), headers: headers, body: jsonEncode(body));
      }else {
        response = await http.put(Uri.parse(apiQueryString + endpoint), headers: headers);
      }
      if(response.statusCode >= 300){
        throw Exception('Erreur : Impossible d\'accéder à la ressource : $endpoint, ${response.statusCode} : ${response.body}');
      } else {
        return jsonDecode(response.body);
      }      
    }

  static Future<bool> delete({required String endpoint, bool token = true}) async{
    Map<String, String> headers = await setHeaders(token);
    final response = await http.delete(Uri.parse(apiQueryString + endpoint), headers: headers);
    if(response.statusCode >= 300){
      throw Exception('Erreur : Impossible d\'accéder à la ressource : $endpoint, ${response.statusCode} : ${response.body}');
    } else {
        return true;
    }   
  }
}