import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/services/api/api_utils_service.dart';
import 'package:la_bonne_franquette_front/services/api/cache_service.dart';
import 'package:la_bonne_franquette_front/views/login/widget/ip_qr_scanner.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../services/api/connection_service.dart';
import '../../../theme.dart';

class ConnectionModalWidget extends StatelessWidget {
  final _serverAddressController = TextEditingController();

  ConnectionModalWidget({super.key}) {
    ApiUtilsService.getUrl().then((value) {
      if (value != null && value.isNotEmpty) {
        _serverAddressController.text = value;
      } else {
        _serverAddressController.text = "";
      }
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

  Future<String?> _scanQRCode(BuildContext context) async {
    final result = await Navigator.push<String>(context, MaterialPageRoute(builder: (context) => const IpQRScanner()));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(children: [
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
                    placeholder: "adresse du serveur",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.qr_code_scanner),
                      onPressed: () async {
                        var reponse = await _scanQRCode(context);
                        if (reponse != null) {
                          _serverAddressController.text = reponse;
                          try {
                            await configure(_serverAddressController.text);
                            print("Connexion réussi.");
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Connexion réussi.")));
                          } catch (e) {
                            print(_serverAddressController.text);
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                                content: Text(e.toString())));
                          }
                        }
                      },
                    ),
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
                      print("Connexion réussi.");
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Connexion réussi.")));
                    } catch (e) {
                      print(_serverAddressController.text);
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                        content: Text(e.toString())));
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
      ]),
    );
  }
}