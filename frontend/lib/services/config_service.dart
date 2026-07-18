import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../config/server_config.dart';

class ConfigService {
  static Map<String, dynamic> _config = {};

  static Future<String> _configFile() async {
    try {
      final dir = await getApplicationSupportDirectory();
      return '${dir.path}/user.json';
    } catch (_) {
      return 'user.json';
    }
  }

  static Future<void> load() async {
    try {
      final path = await _configFile();
      final file = File(path);
      if (await file.exists()) {
        final content = await file.readAsString();
        final decoded = json.decode(content);
        if (decoded is Map<String, dynamic>) {
          _config = decoded;
        } else {
          _config = {};
        }
      }
    } catch (_) {
      _config = {};
    }
  }

  static Future<bool> save(Map<String, dynamic> data) async {
    _config = data;
    try {
      final path = await _configFile();
      final file = File(path);
      await file.writeAsString(json.encode(data));
      return true;
    } catch (_) {
      return false;
    }
  }

  static dynamic get(String key) => _config[key];

  static void set(String key, dynamic value) => _config[key] = value;

  static String get serverHost => _config["server_host"] as String? ?? ServerConfig.defaultHost;
  static int get serverPort => _config["server_port"] as int? ?? ServerConfig.defaultPort;
}