import 'package:la_bonne_franquette_front/services/api/session_service.dart';

import 'api_service.dart';

class CacheService {

  static Future<String> getApiCacheVersion() async {
    try {
      final reponse = await ApiService.get(endpoint: "/cache/version", token: true);
      return reponse.toString();
    } catch (e) {
      throw Exception(e);
    }
  }
}
