import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:la_bonne_franquette_front/services/api/api_service.dart';
import 'package:la_bonne_franquette_front/services/api/api_utils_service.dart';
import 'package:la_bonne_franquette_front/services/stores/secured_storage.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';

class ConnectionService {

  static Future<bool> testConnectionToNewServer({required String adresse}) async {
    final response = await http.get(Uri.parse("http://$adresse/api/v1/test-connection"));
    if (response.statusCode == 200) {
      await ApiUtilsService.setUrl(adresse: adresse);
      return true;
    } else {
      throw Exception("Impossible de se connecter au serveur car l'adresse n'est pas configurer ou le serveur est injoignable");
    }
  }

  static Future<bool> testConnection() async {
      try {
        return await ApiService.get(endpoint: "/test-connection", token: false);
      } catch (e) {
      throw Exception(e);
    }
  }
}