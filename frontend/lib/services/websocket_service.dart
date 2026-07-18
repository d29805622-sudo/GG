import 'package:web_socket_channel/web_socket_channel.dart';

import '../config/server_config.dart';


class WebSocketService {

  WebSocketChannel? channel;

  Stream<String> connect() {

    channel = WebSocketChannel.connect(
      Uri.parse(
        ServerConfig.websocketURL
      )
    );

    return channel!
      .stream
      .map(
        (event) => event.toString()
      );

  }

  void close() {
    channel?.sink.close();
  }

}
