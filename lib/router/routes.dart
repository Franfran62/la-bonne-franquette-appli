import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/views/caisse/caisse_home_page.dart';
import 'package:la_bonne_franquette_front/views/cuisine/cuisine_home_page.dart';
import 'package:la_bonne_franquette_front/views/login/login_page.dart';
import 'package:la_bonne_franquette_front/views/panier/panier_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
        path: '/cuisine',
        builder: (context, state) => CuisineHomePage()
    ),
    GoRoute(
        path: '/panier',
        builder: (context, state) => PanierPage()
    ),
    GoRoute(
        path: '/caisse',
        builder: (context, state) => CaisseHomePage()
    ),
  ],
  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lastVisitedPage', state.uri.toString());
    return null;
  },
);
