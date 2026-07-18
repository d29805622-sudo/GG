import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../config/server_config.dart';
import '../services/config_service.dart';
import '../services/websocket_service.dart';
import '../widgets/video_panel.dart';
import '../widgets/status_panel.dart';
import '../widgets/control_panel.dart';
import 'settings_page.dart';
import 'about_page.dart';


class HomePage extends StatefulWidget {

  const HomePage({
    super.key
  });

  @override
  State<HomePage> createState() => _HomePageState();

}


class _HomePageState extends State<HomePage> {

  final WebSocketService _ws = WebSocketService();

  Stream<String>? _videoStream;

  bool _running = false;

  Timer? _pollTimer;

  String _host = ServerConfig.defaultHost;

  int _port = ServerConfig.defaultPort;

  Map<String, dynamic> _status = {};


  @override
  void initState() {

    super.initState();

    _loadConfig();
  }


  Future<void> _loadConfig() async {

    await ConfigService.load();

    if (!mounted) return;

    final h = ConfigService.get("server_host");

    final p = ConfigService.get("server_port");

    setState(() {

      if (h is String && h.isNotEmpty) _host = h;

      if (p is int && p > 0) _port = p;

    });
  }


  Future<void> _start() async {

    if (_running) return;

    final url = ServerConfig.buildWebSocketUrl(
      host: _host,
      port: _port
    );

    setState(() {

      _videoStream = _ws.connect(url: url);

      _running = true;

    });

    _pollTimer?.cancel();

    _pollTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _pollStatus()
    );

    _pollStatus();
  }


  void _stop() {

    if (!_running) return;

    _ws.close();

    _pollTimer?.cancel();

    _pollTimer = null;

    setState(() {

      _videoStream = null;

      _running = false;

      _status = {};

    });
  }


  Future<void> _pollStatus() async {

    HttpClient? client;

    try {

      final url = ServerConfig.buildHttpUrl(
        host: _host,
        port: _port,
        path: "/api/status"
      );

      client = HttpClient();

      client.connectionTimeout = const Duration(seconds: 2);

      final req = await client.getUrl(Uri.parse(url));

      final res = await req.close();

      if (res.statusCode != 200) return;

      final body = await res.transform(utf8.decoder).join();

      final decoded = json.decode(body);

      if (mounted && decoded is Map<String, dynamic>) {

        setState(() {

          _status = decoded;

        });
      }

    } catch (_) {

    } finally {

      client?.close();

    }
  }


  void _openSettings() {

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const SettingsPage()
      )
    ).then((_) => _loadConfig());
  }


  void _openAbout() {

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AboutPage()
      )
    );
  }


  @override
  void dispose() {

    _pollTimer?.cancel();

    _ws.close();

    super.dispose();
  }


  @override
  Widget build(
    BuildContext context
  ) {

    return Scaffold(

      appBar: AppBar(

        title: const Text("RealtimeFaceSwap v1.1.1"),

        actions: [

          IconButton(

            icon: const Icon(Icons.info_outline),

            onPressed: _openAbout,

          )

        ],

      ),

      body: Row(

        children: [

          Expanded(

            flex: 3,

            child: VideoPanel(stream: _videoStream)

          ),

          Expanded(

            flex: 1,

            child: Column(

              children: [

                StatusPanel(status: _status, host: _host, port: _port),

                const Spacer(),

                ControlPanel(

                  running: _running,

                  onStart: _start,

                  onStop: _stop,

                  onSettings: _openSettings,

                ),

                const SizedBox(height: 20)

              ]

            )

          )

        ],

      ),

    );

  }

}
