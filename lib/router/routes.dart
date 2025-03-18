import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/views/caisse/home/caisse_page.dart';
import 'package:la_bonne_franquette_front/views/caisse/listedecommande/listedecommande_page.dart';
import 'package:la_bonne_franquette_front/views/caisse/prisedecommande/prisedecommande_page.dart';
import 'package:la_bonne_franquette_front/views/cuisine/cuisine_home_page.dart';
import 'package:la_bonne_franquette_front/views/caisse/destination/destination_page.dart';
import 'package:la_bonne_franquette_front/views/login/login_page.dart';
import 'package:la_bonne_franquette_front/views/caisse/paiement/paiement_page.dart';
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
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        name: "cuisine",
        path: '/cuisine', 
        builder: (context, state) => CuisineHomePage()),
      GoRoute(
        name: "caisse",
        path: '/caisse', 
        builder: (context, state) => CaissePage()),
      GoRoute(
        name: "caisse_destination",
        path: '/caisse/destination',
        builder: (context, state) => DestinationPage(),
      ),
      GoRoute(
        name: "caisse_prise_de_commande",
        path: '/caisse/prise-de-commande', 
        builder: (context, state) => PriseDeCommandePage()),
      GoRoute(
        name: "caisse_paiement",
        path: '/caisse/paiement', 
        builder: (context, state) => PaiementPage()),
      GoRoute(
        name: "caisse_liste_commande",
        path: "/caisse/liste-de-commande",
        builder: (context, state) => ListeDeCommandePage())
    ],
    redirect: (context, state) async {
      await saveLastVisitedPage(state.uri.toString());
      return null;
    },
  );
}
