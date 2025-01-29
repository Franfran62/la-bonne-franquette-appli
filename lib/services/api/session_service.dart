import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/user.dart';
import 'package:la_bonne_franquette_front/services/api/api_service.dart';
import 'package:la_bonne_franquette_front/services/api/api_utils_service.dart';
import 'package:go_router/go_router.dart';

import '../stores/secured_storage.dart';

class SessionService {

    static bool connected = false;

  static Future<bool> isConnected() async {
    connected = false;
  String? result = await ApiUtilsService.getComputedUrl();
    if(result.isNotEmpty) {
      try {
        connected = await ApiService.get(endpoint: "/auth/is-connected", token: true);
      } catch (e) {
        print(e);
      }
    }
    return connected;
  }

  static Future<void> login({required User user}) async {
    try {
      final Map<String, dynamic> tokens = await ApiService.post(endpoint: "/auth/login", body: user.toJson(), token: false);
      await ApiUtilsService.setToken(token: tokens['accessToken']);
      await ApiUtilsService.setRefreshToken(token: tokens['refreshToken']);
      connected = true;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> refresh() async {
    try {
      final Map<String, dynamic> newAccessToken = await ApiService.post(endpoint: "/auth/refresh", body: {"refreshToken": await ApiUtilsService.getRefreshToken()}, token: false);
      await ApiUtilsService.setToken(token: newAccessToken['accessToken']);
      connected = true;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> logout(BuildContext context) async {
    try {
      await ApiService.post(
        endpoint: '/auth/logout', 
        body: {
          "accessToken" : await ApiUtilsService.getToken(),
          "refreshToken": await ApiUtilsService.getRefreshToken()
        }, 
        token: true
      );
      await ApiUtilsService.setToken(token: "");
      await ApiUtilsService.setRefreshToken(token: "");
      connected = false;
      context.go('/');
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("Erreur lors de la déconnexion.")));
    }
  }


}