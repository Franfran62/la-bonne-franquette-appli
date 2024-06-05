import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/user.dart';
import 'package:la_bonne_franquette_front/services/api_service.dart';
import 'package:la_bonne_franquette_front/services/authenticator_service.dart';

class UserViewModel {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final apiService = ApiService();
  final authenticatorService = AuthenticatorService();

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get usernameController => _usernameController;
  TextEditingController get passwordController => _passwordController;

  Future<bool> submitForm() async {
    if (_formKey.currentState!.validate()) {
      User user = User(username: _usernameController.text, password: _passwordController.text);
      var response = await apiService.connect(user: user);
      if (!response) {
        throw Exception("Données incorrectes");
      }
      
        // vérifier si l'appli à un cache
        // Si oui : appeler la route /cache/version et récupérer la version du cache
        // Si version du cache back = version du cache front : return true
        // si non : charger la carte et la sauvegarder dans le cache
    }
  }
}
