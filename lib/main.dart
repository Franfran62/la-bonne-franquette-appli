import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/router/routes.dart';
import 'package:la_bonne_franquette_front/services/api/session_service.dart';
import 'package:la_bonne_franquette_front/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Vérifie si l'utilisateur est encore connecté et récupére la dernière page visitée
  await SessionService.isConnected();
  String initialRoute = '/login';
  if (SessionService.connected) {
    final prefs = await SharedPreferences.getInstance();
    initialRoute = prefs.getString('lastVisitedPage') ?? '/';
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {

  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      routerConfig: router,
      title: 'La Bonne Franquette',
      theme: CustomTheme.getTheme()
    );
  }
}