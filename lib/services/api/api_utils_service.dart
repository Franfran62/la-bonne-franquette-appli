import '../stores/secured_storage.dart';

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

  static Future<String> getUrl({String endpoint = ""}) async {
    final String? adresseServeur = await SecuredStorage().readSecret('adresseServeur');
    return 'http://$adresseServeur/api/v1$endpoint';
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