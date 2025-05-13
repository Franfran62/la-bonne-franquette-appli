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
        connected = await ApiService.get(endpoint: "/auth/is-connected", token: true);
    }
    return connected;
  }

  static Future<void> login({required User user}) async {
      final Map<String, dynamic> tokens = await ApiService.post(endpoint: "/auth/login", body: user.toJson(), token: false);
      await ApiUtilsService.setToken(token: tokens['accessToken']);
      await ApiUtilsService.setRefreshToken(token: tokens['refreshToken']);
      connected = true;
  }

  static Future<void> refresh() async {
    final Map<String, dynamic> newAccessToken = await ApiService.post(endpoint: "/auth/refresh", body: {"refreshToken": await ApiUtilsService.getRefreshToken()}, token: false);
    await ApiUtilsService.setToken(token: newAccessToken['accessToken']);
    connected = true;
  }

  static Future<void> logout() async {
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
  } 
}