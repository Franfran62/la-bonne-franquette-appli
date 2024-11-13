import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/router/routes.dart';
import 'package:la_bonne_franquette_front/services/api/session_service.dart';
import 'package:la_bonne_franquette_front/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Vérifie si l'utilisateur est encore connecté et récupére la dernière page visitée
  try {
  await SessionService.isConnected();
  } catch(e) {
    print('Connection error: $e');
  }
  String initialRoute = '/';
  if (SessionService.connected) {
    initialRoute = await getLastVisitedPage();
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {

  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      routerConfig: createRouter(initialRoute),
      title: 'La Bonne Franquette',
      theme: CustomTheme.getTheme()
    );
  }
}