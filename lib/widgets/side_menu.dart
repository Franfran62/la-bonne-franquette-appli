import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/services/api/api_cache.dart';
import 'package:la_bonne_franquette_front/services/api/api_session.dart';
import 'package:la_bonne_franquette_front/exceptions/request_exception.dart';
import 'package:la_bonne_franquette_front/services/utils/error_dialog_extension.dart';

class SideMenu extends StatelessWidget {
  final String destination;
  final BuildContext context;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenu(
      {super.key,
      required this.destination,
      required this.context,
      required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.zero,
          bottomRight: Radius.zero,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 25),
          _buildIconButton(
              Icons.close, () => scaffoldKey.currentState?.closeDrawer()),
          _buildMenuItem(Icons.arrow_forward_rounded, 
              destination == "cuisine" 
                ? "Aller en cuisine"
                : "Aller à la caisse",
              () => context.goNamed(destination)),
          const Spacer(),
          _buildMenuItem(Icons.logout, "Déconnexion", () async {
            try {
              await ApiSession.logout();
            } on RequestException catch (e) {
              await context.showLogoutDialog(e.message);
            }
            GoRouter.of(context).goNamed("login");
          }, color: Colors.red),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 5),
        IconButton(icon: Icon(icon), onPressed: onPressed),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String text, VoidCallback onPressed,
      {Color color = Colors.black}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 17),
        Icon(icon, color: color),
        TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
                color: color, fontSize: 20, fontWeight: FontWeight.normal),
          ),
        ),
      ],
    );
  }
}
