import '../../stores/secured_storage.dart';
import 'package:http/http.dart' as http;

import 'api_service.dart';

class ApiUtilsService {


  static Future<String> getToken() async {
    String? authToken = await SecuredStorage().readSecret('auth-token');
    return authToken ?? "";
  }

  static Future<String> getCacheVersion() async {
    String token = await ApiUtilsService.getToken();
    final response = await http.get(Uri.parse('${ApiService.apiQueryString}/cache/version'), headers: {
      'auth-token': token
    });
    if(response.statusCode >= 300){
      throw Exception('Erreur : Impossible de récupérer la version du cache, ${response.statusCode} : ${response.body}');
    } else {
      return response.body.toString();
    }
  }

}