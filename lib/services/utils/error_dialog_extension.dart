import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension ErrorDialogExtension on BuildContext {
  Future<void> showError(String message, {bool redirect = false, String? route}) {
    return showDialog(
      context: this,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: const Icon(Icons.warning, color: Colors.red),
            ),
            const Text('Erreur'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(this).pop();
              if (redirect && route != null) {
              GoRouter.of(this).pushNamed(route);
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> showLogoutDialog(String message) {
    return showDialog(
      context: this,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: const Icon(Icons.logout, color: Colors.blue),
            ),
            const Text('Deconnexion'),
          ],
        ),
        content: Text("${message} Vous allez être redirigé vers la page de connexion"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(this).pop();
              GoRouter.of(this).pushNamed("login");
            },
            child: const Text('Se reconnecter'),
          ),
        ],
      ),
    );
  }
}
