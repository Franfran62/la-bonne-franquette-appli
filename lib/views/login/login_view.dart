import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:la_bonne_franquette_front/exceptions/request_exception.dart';
import 'package:la_bonne_franquette_front/exceptions/custom_exception.dart';
import 'package:la_bonne_franquette_front/services/utils/error_dialog_extension.dart';
import 'package:la_bonne_franquette_front/views/login/login_viewmodel.dart';
import '../../theme.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool switchView = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    LoginViewModel viewModel = LoginViewModel();

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: screenWidth * 0.4,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: screenWidth * 0.3,
                        child: Image.asset('lib/assets/images/logo.png'),
                      ),
                      _buildTextFormField(
                        controller: _usernameController,
                        label: 'Identifiant',
                        placeholder: 'nom de compte',
                        validator: viewModel.validatePassword,
                      ),
                      _buildTextFormField(
                        controller: _passwordController,
                        label: 'Mot de passe',
                        placeholder: 'mot de passe',
                        obscureText: true,
                        validator: viewModel.validatePassword,
                      ),
                      _buildSwitch(),
                      _buildSubmitButton(viewModel),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    bool obscureText = false,
    required String? Function(String?) validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, top: 10),
      child: TextFormField(
        controller: controller,
        decoration: CustomTheme.getInputDecoration(
          label: label,
          placeholder: placeholder,
          context: context,
        ),
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }

  Widget _buildSwitch() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Caisse'),
          Switch(
            value: switchView,
            onChanged: (value) {
              setState(() {
                switchView = value;
              });
            },
          ),
          const Text('Cuisine'),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(LoginViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            try {
              bool connected = await viewModel.submitForm(
                username: _usernameController.text,
                password: _passwordController.text,
              );
              if (connected) {
                switchView
                    ? context.goNamed('cuisine')
                    : context.goNamed('caisse');
              }
            } on RequestException catch (e) {
              await context.showError(e.message);
            } on JsonException catch (e) {
              await context.showError(e.message);
            } catch (e) {
              await context
                  .showError("Une erreur s'est produite lors de la connexion");
            }
          }
        },
        child: const Text('Valider'),
      ),
    );
  }
}
