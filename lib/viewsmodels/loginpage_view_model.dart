import 'package:la_bonne_franquette_front/models/user.dart';
import 'package:la_bonne_franquette_front/services/api_service.dart';
import 'package:la_bonne_franquette_front/services/database_service.dart';
import 'package:la_bonne_franquette_front/services/initialisation_service.dart';

class LoginPageViewModel {

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
      await ApiService.testConnection();
      User user = User(username: username.trim(), password: password.trim());
      var response = await ApiService.connect(user: user);
      String apiVersion = await ApiService.getCacheVersion(); 
      
      bool initCarte = false;
      if (apiVersion != DatabaseService.databaseVersion) {
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
      DatabaseService.databaseVersion = newVersion;
      return true;  
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
