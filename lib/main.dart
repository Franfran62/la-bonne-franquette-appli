import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/views/login/login_page.dart';
import 'package:la_bonne_franquette_front/theme.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'La Bonne Franquette',
      theme: CustomTheme.getTheme(), 
      home: LoginPage(), 
    );
  }
}