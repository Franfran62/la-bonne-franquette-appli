import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/router/routes.dart';
import 'package:la_bonne_franquette_front/services/api/api_session.dart';
import 'package:la_bonne_franquette_front/services/provider/order_notifier.dart';
import 'package:la_bonne_franquette_front/services/provider/payment_notifier.dart';
import 'package:la_bonne_franquette_front/theme.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_list/order_list_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  String initialRoute = '/';
  // Vérifie si l'utilisateur est encore connecté et récupére la dernière page visitée
  try {
    if (await ApiSession.isConnected()) {
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
        ChangeNotifierProvider(create: (_) => OrderNotifier()),
        ChangeNotifierProvider(create: (_) => PaymentNotifier()),
        ChangeNotifierProvider(create: (_) => OrderListViewModel()),
      ],
      child: MaterialApp.router(
        routerConfig: createRouter(initialRoute),
        title: 'La Bonne Franquette',
        theme: CustomTheme.getTheme(),
      ),
    );
  }
}
