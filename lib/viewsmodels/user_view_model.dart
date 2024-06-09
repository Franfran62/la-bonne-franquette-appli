import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/user.dart';
import 'package:la_bonne_franquette_front/services/api_service.dart';
import 'package:la_bonne_franquette_front/services/authenticator_service.dart';
import 'package:la_bonne_franquette_front/services/cache_service.dart';

class UserViewModel {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final apiService = ApiService();
  final authenticatorService = AuthenticatorService();
  final cacheService = CacheService();

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get usernameController => _usernameController;
  TextEditingController get passwordController => _passwordController;

  Future<bool> submitForm() async {

    if (!_formKey.currentState!.validate()) {
      throw Exception("Données incorrectes");
    } 

    User user = User(username: _usernameController.text, password: _passwordController.text);
    var response = await apiService.connect(user: user);
    if (!response) {
      throw Exception("Données incorrectes");
    }
      
    String? cacheVersion = await cacheService.getCacheVersion();
    String apiVersion = (await getApiCarteVersion()) as String;   
    if (cacheVersion != null && apiVersion == cacheVersion) {
      return true;
    } 

    try {
      loadCarte(newVersion: apiVersion);
      return true;
    } catch (e) {
      throw Exception("Impossible de charger la carte");
    }
}

  void loadCarte({required String newVersion}) async {
    // Charger la carte
    // TOTO
    // update le cache du front
    await cacheService.saveCacheVersion(newVersion);
  }

  Future<Map<String, dynamic>> getApiCarteVersion() async {
     Map<String, dynamic> version = await apiService.get(endpoint: "/cache/version", token: true);
     return version.values.first;
  }

 }
