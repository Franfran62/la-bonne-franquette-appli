import 'dart:convert';
import 'package:la_bonne_franquette_front/services/api/api_utils_service.dart';
import 'package:http/http.dart' as http;

class ApiService{

  static Future<dynamic> get({required String endpoint, bool token = false}) async{

    Map<String, String> headers = await ApiUtilsService.setHeaders(token);
    String url = await ApiUtilsService.getUrl(endpoint: endpoint);
    final response = await http.get(Uri.parse(url), headers: headers);
    if(response.statusCode >= 300){
      throw Exception('Erreur : Impossible d\'accéder à la ressource : $endpoint, ${response.statusCode} : ${response.body}');
    } else {
      return processResponse(response);
    }
  }

  static Future<List<dynamic>> fetchAll({required String endpoint, bool token = false}) async{

    Map<String, String> headers = await ApiUtilsService.setHeaders(token);
    String url = await ApiUtilsService.getUrl(endpoint: endpoint);
    final response = await http.get(Uri.parse(url), headers: headers);
    if(response.statusCode >= 300){
      throw Exception('Erreur : Impossible d\'accéder à la ressource : $endpoint, ${response.statusCode} : ${response.body}');
    } else {
      return processResponse(response);
    }
  }
  
  static Future<dynamic> post({required String endpoint, required Map<dynamic, dynamic> body, bool token = false}) async{
    Map<String, String> headers = await ApiUtilsService.setHeaders(token);
    String url = await ApiUtilsService.getUrl(endpoint: endpoint);
      final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
      if(response.statusCode >= 300){
        throw Exception('Erreur : Impossible d\'accéder à la ressource : $endpoint, ${response.statusCode} : ${response.body}');
      } else {
        return processResponse(response);
      }
    }


  static Future<Map<String, dynamic>> put({required String endpoint, required Map<String, dynamic> body, bool token = false}) async{

    Map<String, String> headers = await ApiUtilsService.setHeaders(token);
    String url = await ApiUtilsService.getUrl(endpoint: endpoint);
        final response = await http.put(Uri.parse(url), headers: headers, body: jsonEncode(body));
      if(response.statusCode >= 300){
        throw Exception('Erreur : Impossible d\'accéder à la ressource : $endpoint, ${response.statusCode} : ${response.body}');
      } else {
        return processResponse(response);
      }      
    }

  static Future<bool> delete({required String endpoint, bool token = true}) async{
    Map<String, String> headers = await ApiUtilsService.setHeaders(token);
    String url = await ApiUtilsService.getUrl(endpoint: endpoint);
    final response = await http.delete(Uri.parse(url), headers: headers);
    if(response.statusCode >= 300){
      throw Exception('Erreur : Impossible d\'accéder à la ressource : $endpoint, ${response.statusCode} : ${response.body}');
    } else {
        return true;
    }   
  }

  static dynamic processResponse(http.Response response) {
      try {
        final contentType = response.headers['content-type'];
        if (contentType != null && contentType.contains('application/json')) {
          return jsonDecode(response.body);
        }
      } catch (e) {
        throw Exception('Erreur de décodage JSON : ${e.toString()}');
      }
    return response.body;
  }
}