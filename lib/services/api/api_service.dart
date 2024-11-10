import 'dart:convert';
import 'package:la_bonne_franquette_front/services/api/api_utils_service.dart';
import 'package:http/http.dart' as http;
import 'package:la_bonne_franquette_front/services/api/session_service.dart';

class ApiService{

  static Future<dynamic> get({required String endpoint, bool token = false}) async{
    return _retryRequest(() async {
        Map<String, String> headers = await ApiUtilsService.setHeaders(token);
        String url = await ApiUtilsService.getUrl(endpoint: endpoint);
        final response = await http.get(Uri.parse(url), headers: headers);
        return response;
      }, token);
  }

  static Future<List<dynamic>> fetchAll({required String endpoint, bool token = false}) async {
    return _retryRequest(() async {
      Map<String, String> headers = await ApiUtilsService.setHeaders(token);
      String url = await ApiUtilsService.getUrl(endpoint: endpoint);
      final response = await http.get(Uri.parse(url), headers: headers);
      return response;
    }, token);
  }
  
  static Future<dynamic> post({required String endpoint, required Map<dynamic, dynamic> body, bool token = false}) async {
    return _retryRequest(() async {
      Map<String, String> headers = await ApiUtilsService.setHeaders(token);
      String url = await ApiUtilsService.getUrl(endpoint: endpoint);
      final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
      return response;
    }, token);
  }

  static Future<Map<String, dynamic>> put({required String endpoint, required Map<String, dynamic> body, bool token = false}) async {
    return _retryRequest(() async {
      Map<String, String> headers = await ApiUtilsService.setHeaders(token);
      String url = await ApiUtilsService.getUrl(endpoint: endpoint);
      final response = await http.put(Uri.parse(url), headers: headers, body: jsonEncode(body));
      return response;
    }, token);
  }

  static Future<bool> delete({required String endpoint, bool token = true}) async {
    return _retryRequest(() async {
      Map<String, String> headers = await ApiUtilsService.setHeaders(token);
      String url = await ApiUtilsService.getUrl(endpoint: endpoint);
      final response = await http.delete(Uri.parse(url), headers: headers);
      return response;
    }, token);
  }

    static Future<T> _retryRequest<T>(Future<http.Response> Function() request, bool token) async {
    final response = await request();
    if (token && response.statusCode == 401) {
      await SessionService.refresh();
      final retryResponse = await request();
      if (retryResponse.statusCode >= 300) {
        throw Exception('Erreur : Impossible d\'accéder à la ressource après réessai, ${retryResponse.statusCode} : ${retryResponse.body}');
      }
      return processResponse(retryResponse);
    }

    if (response.statusCode >= 300) {
      throw Exception('Erreur : Impossible d\'accéder à la ressource : ${response.statusCode} : ${response.body}');
    }
    return processResponse(response);
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