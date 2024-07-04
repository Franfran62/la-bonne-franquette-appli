import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/services/input_service.dart';
import 'package:la_bonne_franquette_front/views/caisse/caisse_home_page.dart';
import 'package:la_bonne_franquette_front/views/cuisine/cuisine_home_page.dart';
import 'package:la_bonne_franquette_front/viewsmodels/loginpage_view_model.dart';
import 'package:la_bonne_franquette_front/widgets/login/connection_modal_widget.dart';
import 'package:la_bonne_franquette_front/widgets/side_menu_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
  LoginPage({super.key});
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool switchView = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    LoginPageViewModel viewModel = LoginPageViewModel();

    return Scaffold(
      drawer: SideMenuWidget(),
      body: SingleChildScrollView(
        child: Stack(children: [
          Center(
            child: Container(
              width: screenWidth * 0.4,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: screenWidth * 0.3,
                      child: Image.asset('lib/assets/images/logo.png'),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: InputService.getInputDecoration(
                            label: 'Identifiant',
                            placeholder: "nom de compte",
                            context: context),
                        validator: (String? value) {
                          return viewModel.validatePassword(value);
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20, top: 10),
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputService.getInputDecoration(
                            label: 'Mot de passe',
                            placeholder: "mot de passe",
                            context: context),
                        obscureText: true,
                        validator: (String? value) {
                          return viewModel.validatePassword(value);
                        },
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(bottom: 20, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: const Text('Caisse'),
                            ),
                            Switch(
                              value: switchView,
                              onChanged: (value) {
                                setState(() {
                                  switchView = value;
                                });
                              },
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: const Text('Cuisine'),
                            ),
                          ],
                        )),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              bool connected = await viewModel.submitForm(
                                  username: _usernameController.text,
                                  password: _passwordController.text);
                              if (connected) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => switchView
                                          ? CuisineHomePage()
                                          : CaisseHomePage()),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
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
          Positioned(
            top: 25,
            right: 25,
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: Dialog(
                        insetPadding: const EdgeInsets.symmetric(
                            vertical: 175, horizontal: 250),
                        child: ConnectionModalWidget(),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.settings),
            ),
          ),
        ]),
      ),
    );
  }
}
