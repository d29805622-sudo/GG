class ServerConfig {
  static const String defaultHost = "192.168.1.100";
  static const int defaultPort = 8000;
  static const String cameraPath = "/camera";
  static const String statusPath = "/api/status";

  static String buildWebSocketUrl({String host = defaultHost, int port = defaultPort, String path = cameraPath}) {
    return "ws://$host:$port$path";
  }

  static String buildHttpUrl({String host = defaultHost, int port = defaultPort, String path = statusPath}) {
    return "http://$host:$port$path";
  }
}