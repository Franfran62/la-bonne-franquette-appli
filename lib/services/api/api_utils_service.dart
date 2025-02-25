import '../stores/secured_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class ApiUtilsService {


  static Future<String> getToken() async {
    String? authToken = await SecuredStorage().readSecret('auth-token');
    return authToken ?? "";
  }

  static Future<void> setToken({required String token}) async {
    await SecuredStorage().writeSecrets('auth-token', token); 
  }

  static Future<String> getRefreshToken() async {
    String? authToken = await SecuredStorage().readSecret('refresh-token');
    return authToken ?? "";
  }

  static Future<void> setRefreshToken({required String token}) async {
    await SecuredStorage().writeSecrets('refresh-token', token); 
  }

  static Future<String?> getUrl({String endpoint = ""}) async {
    return dotenv.env['API_URL'];
  }

  static Future<String> getComputedUrl({String endpoint = ""}) async {
    return 'http://${dotenv.env['API_URL']}/api/v1$endpoint';
  }

  static Future<bool> setUrl({required String adresse}) async {
    try {
      await SecuredStorage().writeSecrets("adresseServeur", adresse);
      return true;
    } catch (e) {
      throw Exception('Erreur : Impossible de sauvegarder l\'adresse du serveur');
    }
  }

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
}