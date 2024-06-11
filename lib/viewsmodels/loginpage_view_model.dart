import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/user.dart';
import 'package:la_bonne_franquette_front/services/api_service.dart';
import 'package:la_bonne_franquette_front/services/authenticator_service.dart';
import 'package:la_bonne_franquette_front/services/cache_service.dart';
import 'package:la_bonne_franquette_front/services/initialisation_service.dart';

class LoginPageViewModel {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final apiService = ApiService();
  final authenticatorService = AuthenticatorService();
  final cacheService = CacheService();

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get usernameController => _usernameController;
  TextEditingController get passwordController => _passwordController;

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

  Future<bool> submitForm() async {

    User user = User(username: _usernameController.text, password: _passwordController.text);
    try {
      var response = await apiService.connect(user: user);
      String? cacheVersion = await cacheService.getCacheVersion();
      String apiVersion = await apiService.getCacheVersion(); 
      
      bool initCarte = false;
      if (cacheVersion == null || apiVersion != cacheVersion) {
        bool initCarte = await loadCarte(newVersion: apiVersion);
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
      InitialisationService.initStores();
      await cacheService.saveCacheVersion(newVersion);
      return true;  
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
