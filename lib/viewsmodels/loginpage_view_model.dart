import 'package:la_bonne_franquette_front/models/user.dart';
import 'package:la_bonne_franquette_front/services/api_service.dart';
import 'package:la_bonne_franquette_front/services/authenticator_service.dart';
import 'package:la_bonne_franquette_front/services/cache_service.dart';
import 'package:la_bonne_franquette_front/services/initialisation_service.dart';
import 'package:la_bonne_franquette_front/stores/secured_storage.dart';

class LoginPageViewModel {
 
  final apiService = ApiService();
  final authenticatorService = AuthenticatorService();

  String? validateServerAddress(String? value){
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer l\'adresse du serveur';
    }
    return null;
  }

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

  Future<bool> connectToServer({required String serverAddress}) async {
    if(await apiService.testConnection(serverAddress)){
      SecuredStorage().writeSecrets('adresseServeur', serverAddress);
      return true;
    }
    return false;
  }

  Future<bool> submitForm({required String username, required String password, required String serverAddress}) async {
    if (!await connectToServer(serverAddress: serverAddress)) {
      throw Exception('Impossible de se connecter au serveur');
    }
    await ApiService.setBaseAddressServer();
    await CacheService.clearCache();
    User user = User(username: username, password: password);
    try {
      var response = await apiService.connect(user: user);
      String? cacheVersion = await CacheService.getCacheVersion();
      String apiVersion = await apiService.getCacheVersion(); 
      
      bool initCarte = false;
      if (cacheVersion == null || apiVersion != cacheVersion) {
        initCarte = await loadCarte(newVersion: apiVersion);
      } else {
        initCarte = true;
      }

      return response && initCarte;

    } catch (e) {
      throw Exception(e.toString());  
    }
}  

  Future<bool> loadCarte({required String newVersion}) async {
    try {
      await InitialisationService.initStores();
      await CacheService.saveCacheVersion(newVersion);
      return true;  
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
