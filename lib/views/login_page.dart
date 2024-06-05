import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/user.dart';
import 'package:la_bonne_franquette_front/viewsmodels/user_view_model.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'username'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Entrer votre nom d\'utilisateur';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Entrez votre mot de passe';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  UserViewModel userViewModel = UserViewModel();
                  userViewModel.submitForm();
                  ScaffoldMessenger.of(context)
                     .showSnackBar(const SnackBar(content: Text('Congrats =)')));
                } catch (e) {
                   ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}