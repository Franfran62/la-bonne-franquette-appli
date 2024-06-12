import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/services/cache_service.dart';
import 'package:la_bonne_franquette_front/views/login_page.dart';
import 'package:la_bonne_franquette_front/theme.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await CacheService.clearCache();
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