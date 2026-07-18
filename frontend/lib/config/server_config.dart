class ServerConfig {

  static const String defaultHost = "127.0.0.1";

  static const int defaultPort = 8000;


  static String buildWebSocketUrl({
    required String host,
    required int port
  }) {

    return "ws://$host:$port/camera";

  }


  static String buildHttpUrl({
    required String host,
    required int port,
    String path = ""
  }) {

    return "http://$host:$port$path";

  }

}
