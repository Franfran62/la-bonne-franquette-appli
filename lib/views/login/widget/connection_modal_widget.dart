import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/services/api/api_utils_service.dart';
import 'package:la_bonne_franquette_front/services/api/cache_service.dart';
import 'package:la_bonne_franquette_front/services/stores/secured_storage.dart';

import '../../../services/api/connection_service.dart';
import '../../../theme.dart';

class ConnectionModalWidget extends StatelessWidget {
  final _serverAddressController = TextEditingController();

  ConnectionModalWidget({super.key}) {
    ApiUtilsService.getUrl().then((value) => {
          _serverAddressController.text = value!.isNotEmpty ? value : ""
        });
  }

  String? validateServerAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer l\'adresse du serveur';
    }
    return null;
  }

  Future<bool> configure(String adresse) async {
    try {
      await ConnectionService.testConnectionToNewServer(adresse: adresse);
      await ApiUtilsService.setUrl(adresse: adresse);
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Text('Paramètre')),
          Container(
            margin:
                const EdgeInsets.only(bottom: 25, top: 25, left: 50, right: 50),
            child: TextFormField(
              controller: _serverAddressController,
              decoration: CustomTheme.getInputDecoration(
                  label: 'Serveur',
                  placeholder: "adresse de serveur (ex: 182.168.1.0:8008)",
                  context: context),
              validator: (String? value) {
                return validateServerAddress(value);
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 25),
            child: TextButton(
                child: const Text('Rafraichir le cache',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal)),
                onPressed: () async {
                  try {
                    await CacheService.refreshCacheWhileDisconnected();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Cache rafraîchi.")));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(e.toString())));
                  }
                }),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 25),
            child: ElevatedButton(
                child: const Text('Enregistrer'),
                onPressed: () async {
                  try {
                    await configure(_serverAddressController.text);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Connexion réussi.")));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                      content: Text(e.toString())));
                       //  content: Text("Impossible de contacter le serveur.")));
                  }
                }),
          ),
        ],
      ),
      Positioned(
        top: 10,
        right: 10,
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close),
        ),
      )
    ]);
  }
}
