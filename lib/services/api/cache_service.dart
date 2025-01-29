import 'package:la_bonne_franquette_front/services/api/session_service.dart';

import 'api_service.dart';

class CacheService {

  static Future<void> refreshCache() async {
    try {
      await SessionService.isConnected();
      if (SessionService.connected) {
        await ApiService.get(endpoint: "/cache/rafraichir", token: false);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

    static Future<void> refreshCacheWhileDisconnected() async {
    try {
      await ApiService.get(endpoint: "/cache/rafraichir", token: false);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> getApiCacheVersion() async {
    try {
      final reponse = await ApiService.get(endpoint: "/cache/version", token: true);
      return reponse.toString();
    } catch (e) {
      throw Exception(e);
    }
  }
}
