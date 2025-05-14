import 'package:la_bonne_franquette_front/models/user.dart';
import 'package:la_bonne_franquette_front/services/api/api_cache.dart';
import 'package:la_bonne_franquette_front/services/api/api_session.dart';
import 'package:la_bonne_franquette_front/exceptions/request_exception.dart';
import 'package:la_bonne_franquette_front/services/stores/database_request.dart';
import 'package:la_bonne_franquette_front/services/stores/database_setup.dart';

class LoginViewModel {
  static final LoginViewModel _singleton = LoginViewModel._internal();

  factory LoginViewModel() {
    return _singleton;
  }

  LoginViewModel._internal();

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

  Future<bool> submitForm(
      {required String username, required String password}) async {
    try {
      User user = User(username: username.trim(), password: password.trim());
      await ApiSession.login(user: user);
      final String apiVersion = await ApiCache.getApiCacheVersion();
      bool isStores = false;
      if ((apiVersion != DatabaseRequest.databaseVersion)) {
        isStores = await loadStores(newVersion: apiVersion);
      } else {
        isStores = true;
      }
      return isStores;
    } on RequestException {
      rethrow;
    } catch (e) {
      throw Exception("Une erreur s'est produite lors de la connexion");
    }
  }

  Future<bool> loadStores({required String newVersion}) async {
    try {
      await DatabaseSetup.initStores();
      DatabaseRequest.databaseVersion = newVersion;
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }
}
