import 'api_request.dart';

class ApiCache {
  static Future<String> getApiCacheVersion() async {
    final reponse =
        await ApiRequest.get(endpoint: "/cache/version", token: true);
    return reponse.toString();
  }
}
