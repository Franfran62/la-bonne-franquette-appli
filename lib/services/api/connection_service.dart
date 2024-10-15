import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:la_bonne_franquette_front/router/routes.dart';
import 'package:la_bonne_franquette_front/services/api/api_service.dart';
import 'package:la_bonne_franquette_front/stores/secured_storage.dart';
import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/views/login/login_page.dart';

import '../../models/user.dart';

class ConnectionService {

  static Future<void> setBaseAddressServer() async {
    await SecuredStorage().readSecret('adresseServeur').then((value) => {
      ApiService.apiQueryString = 'http://$value/api/v1'
    });
  }

  static Future<bool> testConnection({String adresse = ""}) async {
    http.Response response;
    if (adresse == "") {
      String serverAddress = await SecuredStorage().readSecret("adresseServeur") as String;
      response = await http.get(Uri.parse("http://$serverAddress/api/v1/testConnection"));
    } else {
      response = await http.get(Uri.parse("http://$adresse/api/v1/testConnection"));
    }

    if (response.statusCode == 200) {
      await setBaseAddressServer();
      return true;
    } else {
      throw Exception("Impossible de se connecter au serveur car l'adresse n'est pas configurer ou le serveur est injoignable");
    }
  }

  static Future<bool> connect({required User user}) async {
    Map<String, String> headers = await ApiService.setHeaders(false);
    final response = await http.post(Uri.parse('${ApiService.apiQueryString}/auth/login'), headers: headers, body: jsonEncode(user.toJson()));
    if(response.statusCode >= 300){
      throw Exception('Erreur : Impossible de se connecter, ${response.statusCode} : ${response.body}');
    } else {
      Map<String, dynamic> token = jsonDecode(response.body);
      SecuredStorage().writeSecrets("auth-token", token['token']);
      return true;
    }
  }

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
    context.go('/');
  }
}