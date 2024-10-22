import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/user.dart';
import 'package:la_bonne_franquette_front/services/api/api_service.dart';
import 'package:la_bonne_franquette_front/services/api/api_utils_service.dart';
import 'package:go_router/go_router.dart';

class SessionService {

    static bool connected = false;

  static Future<void> isConnected() async {
    try {
      connected = await ApiService.get(endpoint: "/auth/is-connected", token: true);
    } catch (e) {
      throw Exception(e);
    }
  }

    static Future<void> login({required User user}) async {
    try {
      final Map<String, dynamic> token = await ApiService.post(endpoint: "/auth/login", body: user.toJson(), token: false);
      await ApiUtilsService.setToken(token: token['token']);
      connected = true;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> logout(BuildContext context) async {
    Map tokenJSON = {
      "token" : await ApiUtilsService.getToken()
    };
    try {
      ApiService.post(endpoint: '/auth/logout', body: tokenJSON, token: true);
      ApiUtilsService.setToken(token: "");
      connected = false;
      context.go('/');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("Erreur lors de la déconnexion.")));
    }
  }


}