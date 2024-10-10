import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/services/api/connection_service.dart';

class SideMenuWidget extends StatelessWidget {
  final Widget destination;
  final BuildContext context;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenuWidget(
      {super.key,
      required this.destination,
      required this.context,
      required this.scaffoldKey});

  void handleScreenSwap() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => destination));
  }

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
          _buildIconButton(Icons.close, () => scaffoldKey.currentState?.closeDrawer()),
          _buildMenuItem(Icons.arrow_forward_rounded, "Changer de vue", handleScreenSwap),
          const Spacer(),
          _buildMenuItem(Icons.logout, "Déconnexion", () async => await ConnectionService.logout(context), color: Colors.red),
          SizedBox(height: 10,)
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

  Widget _buildMenuItem(IconData icon, String text, VoidCallback onPressed, {Color color = Colors.black}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 17),
        Icon(icon, color: color),
        TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.normal),
          ),
        ),
      ],
    );
  }
}