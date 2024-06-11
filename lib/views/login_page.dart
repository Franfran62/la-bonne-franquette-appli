import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/models/user.dart';
import 'package:la_bonne_franquette_front/theme.dart';
import 'package:la_bonne_franquette_front/viewsmodels/user_view_model.dart';

class LoginPage extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  LoginPage({super.key});


  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    UserViewModel userViewModel = UserViewModel();

    return Scaffold(
      body: Center(
         child: Container(
          width: screenWidth * 0.4,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: screenWidth * 0.3,
                  child:
                    Image.asset('lib/assets/images/logo.png'),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: 
                    TextFormField(
                      decoration: getInputDecoration(label: 'Identifiant', placeholder: "nom de compte", context:  context),
                      validator: (String? value) {
                        return userViewModel.validatePassword(value);
                      },
                    ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20, top: 10),
                  child: 
                    TextFormField(
                      decoration: getInputDecoration(label: 'Mot de passe', placeholder: "mot de passe", context: context),
                      obscureText: true,
                      validator: (String? value) {
                        return userViewModel.validatePassword(value);
                      },
                    ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child:
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            bool connected = await userViewModel.submitForm();
                            ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(connected.toString())));
                          } catch (e) {
                            ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(e.toString())));
                          }
                        }
                      },
                      child: const Text('Valider'),
                    ),
                ),
              ],  
            ),
          ),
         ),
      ),
    );
  }

  InputDecoration getInputDecoration({required String label, required String placeholder, required BuildContext context}) {
    ThemeData theme = Theme.of(context);
    return InputDecoration(
      labelText: label,
      labelStyle: theme.textTheme.bodyMedium,
      hintText: 'Entrez votre $placeholder', 
      hintStyle: theme.textTheme.bodyMedium,
      floatingLabelBehavior: FloatingLabelBehavior.always,
    );
  }
}