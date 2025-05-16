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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrderNotifier()),
        ChangeNotifierProvider(create: (_) => PaymentNotifier()),
        ChangeNotifierProvider(create: (_) => OrderListViewModel()),
      ],
      child: MaterialApp.router(
        routerConfig: createRouter("/"),
        title: 'La Bonne Franquette',
        theme: CustomTheme.getTheme(),
      ),
    );
  }
}
