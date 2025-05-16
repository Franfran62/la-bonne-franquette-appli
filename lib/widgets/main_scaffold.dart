import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/exceptions/request_exception.dart';
import 'package:la_bonne_franquette_front/router/routes.dart';
import 'package:la_bonne_franquette_front/services/api/api_session.dart';
import 'package:la_bonne_franquette_front/services/utils/error_dialog_extension.dart';
import 'package:la_bonne_franquette_front/widgets/side_menu.dart';

class MainScaffold extends StatefulWidget {
  final Widget body;
  final String destination;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String? title;

  MainScaffold(
      {required this.body,
      required this.destination,
      required this.scaffoldKey,
      this.title,
      super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);

    void goBack() async {
      final router = GoRouter.of(context);
      final matches = router.routerDelegate.currentConfiguration;
      if (matches.isNotEmpty) {
        final routeName = matches.last.route.name;
        final redirect = await getBackPage(routeName);
        if (redirect == "login") {
          try {
            await ApiSession.logout();
          } on RequestException catch (e) {
            await context.showLogoutDialog(e.message);
          } catch (e) {
            await context.showError("Une erreur inattendue s'est produite");
          }
        }
        context.goNamed(redirect);
      }
    }

    return Scaffold(
      key: widget.scaffoldKey,
      drawer: SideMenu(
          destination: widget.destination,
          context: context,
          scaffoldKey: widget.scaffoldKey),
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => widget.scaffoldKey.currentState?.openDrawer()),
        title: Text(widget.title ?? ""),
        actions: [
          InkWell(
            onTap: goBack,
            child: Icon(Icons.arrow_back),
          ),
          SizedBox(width: 20.0),
        ],
      ),
      body: widget.body,
    );
  }
}
