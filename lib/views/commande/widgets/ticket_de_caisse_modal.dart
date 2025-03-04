import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/theme.dart';
import 'package:la_bonne_franquette_front/views/commande/viewmodel/commande_view_model.dart';

class TicketDeCaisseModal extends StatefulWidget {
  @override
  _TicketDeCaisseModalState createState() => _TicketDeCaisseModalState();
}

class _TicketDeCaisseModalState extends State<TicketDeCaisseModal> {

  String email = '';
  final _formKey = GlobalKey<FormState>();
  final CommandeViewModel viewModel = CommandeViewModel();

  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  void sendEmail() async {
    if (_formKey.currentState!.validate()) {
      bool emailSend = await viewModel.sendEmail(email, true);
      if (emailSend) {
        Navigator.of(context).pop();
      }  
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Envoyer le ticket de caisse',
              style: Theme.of(context).textTheme.headlineMedium),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
      content: Container(
        width: 400,
        height: 200,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                decoration: CustomTheme.getInputDecoration(
                  label: "Adresse email",
                  placeholder: "Saisissez l'adresse email du client",
                  context: context,
                ),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir une adresse email';
                  } else if (!_isEmailValid(value)) {
                    return 'Veuillez saisir une adresse email valide';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: sendEmail,
                child: Text("Envoyer",
                    style: Theme.of(context).textTheme.bodyLarge),
              )
            ],
          ),
        ),
      ),
    );
  }
}
