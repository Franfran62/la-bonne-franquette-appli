import 'package:la_bonne_franquette_front/models/user.dart';
import 'package:la_bonne_franquette_front/services/api/api_request.dart';
import 'package:la_bonne_franquette_front/services/api/api_utils.dart';


class ApiSession {
  static bool connected = false;

  static Future<bool> isConnected() async {
    connected = false;
    String? result = await ApiUtils.getComputedUrl();
    if (result.isNotEmpty) {
      connected =
          await ApiRequest.get(endpoint: "/auth/is-connected", token: true);
    }
    return connected;
  }

  static Future<void> login({required User user}) async {
    final Map<String, dynamic> tokens = await ApiRequest.post(
        endpoint: "/auth/login", body: user.toJson(), token: false);
    await ApiUtils.setToken(token: tokens['accessToken']);
    await ApiUtils.setRefreshToken(token: tokens['refreshToken']);
    connected = true;
  }

  static Future<void> refresh() async {
    final Map<String, dynamic> newAccessToken = await ApiRequest.post(
        endpoint: "/auth/refresh",
        body: {"refreshToken": await ApiUtils.getRefreshToken()},
        token: false);
    await ApiUtils.setToken(token: newAccessToken['accessToken']);
    connected = true;
  }

  static Future<void> logout() async {
    await ApiRequest.post(
        endpoint: '/auth/logout',
        body: {
          "accessToken": await ApiUtils.getToken(),
          "refreshToken": await ApiUtils.getRefreshToken()
        },
        token: true);
    await ApiUtils.setToken(token: "");
    await ApiUtils.setRefreshToken(token: "");
    connected = false;
  }
}
