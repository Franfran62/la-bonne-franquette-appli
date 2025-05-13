import 'package:la_bonne_franquette_front/models/user.dart';
import 'package:la_bonne_franquette_front/services/api/cache_service.dart';
import 'package:la_bonne_franquette_front/services/api/session_service.dart';
import 'package:la_bonne_franquette_front/exception/api_exception.dart';
import 'package:la_bonne_franquette_front/services/stores/database_service.dart';
import 'package:la_bonne_franquette_front/services/stores/initialisation_service.dart';

class LoginPageViewModel {

  static final LoginPageViewModel _singleton = LoginPageViewModel._internal();  

  factory LoginPageViewModel() {
    return _singleton;
  }

  LoginPageViewModel._internal();

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre nom d\'utilisateur';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre mot de passe';
    }
    return null;
  }

  Future<bool> submitForm({required String username, required String password}) async {
    try {
      User user = User(username: username.trim(), password: password.trim());
      await SessionService.login(user: user);
      final String apiVersion = await CacheService.getApiCacheVersion();
      bool isStores = false;
      if ((apiVersion != DatabaseService.databaseVersion)) {
        isStores = await loadStores(newVersion: apiVersion);
      } else {
        isStores = true;
      }
      return isStores;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw Exception("Une erreur s'est produite lors de la connexion");
    }
}

  Future<bool> loadStores({required String newVersion}) async {
    try {
      await InitialisationService.initStores();
      DatabaseService.databaseVersion = newVersion;
      return true;  
    } catch (e) {
      throw Exception(e);
    }
  }
}
