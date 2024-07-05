import 'package:la_bonne_franquette_front/services/api_service.dart';
import 'package:la_bonne_franquette_front/stores/secured_storage.dart';
import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/views/login_page.dart';

class ConnectionService {

  static logout(BuildContext context) {
    Map tokenJSON = {
      "token" : SecuredStorage().readSecret('auth-token')
    };
    try {
  ApiService.post(endpoint: '/auth/logout', body: tokenJSON, token: true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("Erreur lors de la déconnexion.")));
    }
    SecuredStorage().writeSecrets('auth-token', "");
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginPage()));
    ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("Vous êtes déconnecté.")));
  }
}