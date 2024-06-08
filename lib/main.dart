import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/services/api_service.dart';
import 'package:la_bonne_franquette_front/stores/secured_storage.dart';
import 'package:la_bonne_franquette_front/views/login_page.dart';
import 'package:la_bonne_franquette_front/theme.dart';
import 'package:get_storage/get_storage.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  SecuredStorage securedStorage = SecuredStorage();
  await securedStorage.writeSecrets('urlApi', "http://localhost:8080/api");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'La Bonne Franquette',
      theme: CustomTheme.getTheme(), 
      home: LoginPage(), // Lancez LoginPage au démarrage
    );
  }
}