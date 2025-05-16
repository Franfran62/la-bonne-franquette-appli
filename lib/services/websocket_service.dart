import 'package:la_bonne_franquette_front/exceptions/request_exception.dart';
import 'package:la_bonne_franquette_front/services/api/api_utils.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

typedef MessageCallback = void Function(String message);

class WebSocketService {
  
  StompClient? stompClient;
  String? url;

  Future<void> setWebSocketServerAdress() async {
    await ApiUtils.getUrl().then((value) {
      url = 'ws://$value/ws';
    });
  }

  void connect(MessageCallback messageReceived) async {
    int maxReconnectAttempts = 5; 
    int reconnectAttempts = 0;

    stompClient = StompClient(
      config: StompConfig(
        url: url!,
        onConnect: (StompFrame frame) {
          stompClient?.subscribe(
            destination: '/socket/order',
            callback: (frame) {
              if (frame.body != null) {
                messageReceived(frame.body!);
              }
            },
          );
        },
        beforeConnect: () async {
          if (reconnectAttempts < maxReconnectAttempts) {
            await Future.delayed(const Duration(milliseconds: 1000)); 
            reconnectAttempts++;
          } else {
            stompClient?.deactivate();
            throw ServerErrorException(500, stompClient.toString());
          }
        },
        onStompError: (p0) => throw ServerErrorException(500, stompClient.toString()),
        stompConnectHeaders: {'auth-token': await ApiUtils.getToken()},
        webSocketConnectHeaders: {'auth-token': await ApiUtils.getToken()}, 
      ),
    );

    stompClient?.activate();
  }

  void disconnect() {
    stompClient?.deactivate();
  }
}
