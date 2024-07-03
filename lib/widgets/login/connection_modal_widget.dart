import 'package:flutter/material.dart';
import 'package:la_bonne_franquette_front/services/api_service.dart';
import 'package:la_bonne_franquette_front/services/input_service.dart';
import 'package:la_bonne_franquette_front/stores/secured_storage.dart';

class ConnectionModalWidget extends StatelessWidget {

  final _serverAddressController = TextEditingController();

  late String adresseServeur = "";


  ConnectionModalWidget({super.key}) {
    SecuredStorage().readSecret('adresseServeur').then((value) =>{
      if(value!.isNotEmpty){
        adresseServeur = value
      } else {
        adresseServeur = ""
      }
    });
  }

  String? validateServerAddress(String? value){
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer l\'adresse du serveur';
    }
    return null;
  }

  Future<bool> saveAddress(String adresse) async {
    if(adresse.isEmpty) return false;
    bool result = await ApiService.testConnection(adresse);
    if(result){
      adresseServeur = adresse;
      SecuredStorage().writeSecrets('adresseServeur',adresseServeur);
      ApiService.setBaseAddressServer();
      return true;
    }else{
      return false;
    }
  }

  Future<void> rafraichirCache() async {
    SecuredStorage().readSecret('adresseServeur').then((value) => {
      if(value!.isNotEmpty){
        ApiService().get(endpoint: "/cache/reinitialiser")
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, 
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Text('Paramétres')
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 25, top: 25, left: 50, right: 50),
                child: TextFormField(
                  controller: _serverAddressController,
                  decoration: InputService.getInputDecoration(
                      label: 'Serveur',
                      placeholder:
                          "adresse de serveur, ex: 182.168.1.0:8008",
                      context: context),
                  validator: (String? value) {
                    return validateServerAddress(value);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 25),
                child: ElevatedButton(
                  child: const Text('Rafraichir le cache'),
                  onPressed: () async => await rafraichirCache()
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 25),
                child: ElevatedButton(
                  child: const Text('Enregistrer'),
                  onPressed: () async => {
                    await saveAddress(_serverAddressController.text) 
                      ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Connexion enregistrée")))
                      : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Impossible de contacter le serveur.")))
                    }
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close),
          ),
        )
      ] 
    );
  }
}
