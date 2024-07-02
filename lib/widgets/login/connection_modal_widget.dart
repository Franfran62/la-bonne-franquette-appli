import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/services/input_service.dart';
import 'package:la_bonne_franquette_front/viewsmodels/loginpage_view_model.dart';

class ConnectionModalWidget extends StatelessWidget {

  final _serverAddressController = TextEditingController();
  final LoginPageViewModel viewModel;

  ConnectionModalWidget({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('showModalBottomSheet'),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                          controller: _serverAddressController,
                          decoration: InputService.getInputDecoration(
                              label: 'Serveur',
                              placeholder:
                                  "adresse de serveur, ex: 182.168.1.0:8008",
                              context: context),
                          validator: (String? value) {
                            return viewModel.validateServerAddress(value);
                          },
                        ),
                      ),
                      ElevatedButton(
                        child: const Text('Fermer'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
