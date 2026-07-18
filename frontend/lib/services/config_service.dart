import 'dart:convert';
import 'dart:io';


class ConfigService {

  static const String _configFile = "user.json";

  static Map<String, dynamic> _config = {};


  static Future<void> load() async {

    try {

      final file = File(_configFile);

      if (await file.exists()) {

        final content = await file.readAsString();

        _config = json.decode(content);

      }

    } catch (e) {

      _config = {};

    }

  }


  static Future<void> save(Map<String, dynamic> data) async {

    _config = data;

    final file = File(_configFile);

    await file.writeAsString(

      json.encode(data)

    );

  }


  static dynamic get(String key) {

    return _config[key];

  }


  static void set(String key, dynamic value) {

    _config[key] = value;

  }

}
