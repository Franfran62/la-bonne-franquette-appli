import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/router/routes.dart';
import 'package:la_bonne_franquette_front/services/api/session_service.dart';
import 'package:la_bonne_franquette_front/services/provider/commande_notifier.dart';
import 'package:la_bonne_franquette_front/services/provider/paiement_notifier.dart';
import 'package:la_bonne_franquette_front/theme.dart';
import 'package:la_bonne_franquette_front/views/caisse/listedecommande/viewmodel/listedecommande_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  String initialRoute = '/';
  // Vérifie si l'utilisateur est encore connecté et récupére la dernière page visitée
  try {
    if (await SessionService.isConnected()) {
      initialRoute = await getLastVisitedPage();
    }
  } catch (e) {
    print('Connection error: $e');
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CommandeNotifier()),
        ChangeNotifierProvider(create: (_) => PaiementNotifier()),
        ChangeNotifierProvider(create: (_) => ListedeCommandeViewModel()),
      ],
      child: MaterialApp.router(
        routerConfig: createRouter(initialRoute),
        title: 'La Bonne Franquette',
        theme: CustomTheme.getTheme(),
      ),
    );
  }
}
