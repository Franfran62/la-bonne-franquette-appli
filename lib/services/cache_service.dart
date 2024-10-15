import '../stores/secured_storage.dart';
import 'api/api_service.dart';

class CacheService {
  static Future<void> rafraichirCache() async {
    SecuredStorage().readSecret('adresseServeur').then((value) => {
          if (value!.isNotEmpty)
            {ApiService.get(endpoint: "/cache/rafraichir", token: true)}
        });
  }
}
