import 'package:la_bonne_franquette_front/stores/secured_storage.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

typedef MessageCallback = void Function(String message);

class WebSocketService {
  
  StompClient? stompClient;
  String? url;

  Future<void> setBaseAddressServer() async {
    await SecuredStorage().readSecret('adresseServeur').then((value) {
      url = 'ws://$value/ws';
    });
  }

  void connect(MessageCallback messageRecu) async {
    int maxReconnectAttempts = 5; 
    int reconnectAttempts = 0;

    stompClient = StompClient(
      config: StompConfig(
        url: url!,
        onConnect: (StompFrame frame) {
          stompClient?.subscribe(
            destination: '/socket/commande',
            callback: (frame) {
              if (frame.body != null) {
                messageRecu(frame.body!);
              }
            },
          );
        },
        beforeConnect: () async {
          if (reconnectAttempts < maxReconnectAttempts) {
            print('Tentative de connexion WebSocket...');
            await Future.delayed(const Duration(milliseconds: 1000)); 
            reconnectAttempts++;
          } else {
            print("Nombre maximal de tentatives de connexion atteint.");
            stompClient?.deactivate();
          }
        },
        stompConnectHeaders: {'auth-token': await SecuredStorage().readSecret("auth-token") ?? ""},
        webSocketConnectHeaders: {'auth-token': await SecuredStorage().readSecret("auth-token") ?? ""}, 
      ),
    );

    stompClient?.activate();
  }

  void disconnect() {
    stompClient?.deactivate();
  }
}
