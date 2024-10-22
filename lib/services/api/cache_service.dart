import 'package:la_bonne_franquette_front/services/api/connection_service.dart';

import 'api_service.dart';

class CacheService {

  static Future<void> refreshCache() async {
    try {
      final bool connected = await ConnectionService.isConnected();
      if (connected) {
        await ApiService.get(endpoint: "/cache/rafraichir", token: true);
      }
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
