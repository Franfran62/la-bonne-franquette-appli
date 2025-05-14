import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/views/cashier/home/cashier_home_view.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_list/order_list_view.dart';
import 'package:la_bonne_franquette_front/views/cashier/order_entry/order_entry_view.dart';
import 'package:la_bonne_franquette_front/views/kitchen/kitchen_home_view.dart';
import 'package:la_bonne_franquette_front/views/cashier/destination/destination_view.dart';
import 'package:la_bonne_franquette_front/views/login/login_view.dart';
import 'package:la_bonne_franquette_front/views/cashier/payment/payment_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLastVisitedPage(String route) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('lastVisitedPage', route);
}

Future<String> getLastVisitedPage() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('lastVisitedPage') ?? '/';
}

GoRouter createRouter(String initialRoute) {
  return GoRouter(
    initialLocation: initialRoute,
    routes: [
      GoRoute(
        name: "login",
        path: '/',
        builder: (context, state) => LoginView(),
      ),
      GoRoute(
          name: "cuisine",
          path: '/cuisine',
          builder: (context, state) => KitchenHomeView()),
      GoRoute(
          name: "caisse",
          path: '/caisse',
          builder: (context, state) => CashierHomeView()),
      GoRoute(
        name: "caisse_destination",
        path: '/caisse/destination',
        builder: (context, state) => DestinationView(),
      ),
      GoRoute(
          name: "caisse_prise_de_commande",
          path: '/caisse/prise-de-commande',
          builder: (context, state) => OrderEntryView()),
      GoRoute(
          name: "caisse_paiement",
          path: '/caisse/paiement',
          builder: (context, state) => PaymentView()),
      GoRoute(
          name: "caisse_liste_commande",
          path: "/caisse/liste-de-commande",
          builder: (context, state) => OrderListView())
    ],
    redirect: (context, state) async {
      await saveLastVisitedPage(state.uri.toString());
      return null;
    },
  );
}
