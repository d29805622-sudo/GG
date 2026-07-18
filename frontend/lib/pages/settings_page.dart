import 'package:flutter/material.dart';

import '../config/server_config.dart';
import '../services/config_service.dart';


class SettingsPage extends StatefulWidget {

  const SettingsPage({
    super.key
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();

}


class _SettingsPageState extends State<SettingsPage> {

  late TextEditingController _hostCtrl;

  late TextEditingController _portCtrl;

  bool _saving = false;

  @override
  void initState() {

    super.initState();

    _hostCtrl = TextEditingController(
      text: ServerConfig.defaultHost
    );

    _portCtrl = TextEditingController(
      text: ServerConfig.defaultPort.toString()
    );

    _loadSaved();
  }


  Future<void> _loadSaved() async {

    await ConfigService.load();

    final h = ConfigService.get("server_host");

    final p = ConfigService.get("server_port");

    setState(() {

      if (h is String && h.isNotEmpty) {

        _hostCtrl.text = h;

      }

      if (p is int && p > 0) {

        _portCtrl.text = p.toString();

      }

    });
  }


  Future<void> _save() async {

    setState(() => _saving = true);

    final data = <String, dynamic>{};

    data["server_host"] = _hostCtrl.text.trim();

    final port = int.tryParse(_portCtrl.text.trim());

    data["server_port"] = port ?? ServerConfig.defaultPort;

    await ConfigService.save(data);

    setState(() => _saving = false);

    if (mounted) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(content: Text("已保存"))

      );

      Navigator.of(context).pop(true);

    }
  }


  @override
  void dispose() {

    _hostCtrl.dispose();

    _portCtrl.dispose();

    super.dispose();
  }


  @override
  Widget build(
    BuildContext context
  ) {

    return Scaffold(

      appBar: AppBar(

        title: const Text("软件设置")

      ),

      body: ListView(

        padding: const EdgeInsets.all(16),

        children: [

          const Text(
            "服务器地址",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
          ),

          const SizedBox(height: 8),

          TextField(

            controller: _hostCtrl,

            decoration: const InputDecoration(

              labelText: "Host",

              hintText: "例如 127.0.0.1",

              border: OutlineInputBorder()

            ),

          ),

          const SizedBox(height: 12),

          TextField(

            controller: _portCtrl,

            keyboardType: TextInputType.number,

            decoration: const InputDecoration(

              labelText: "Port",

              hintText: "例如 8000",

              border: OutlineInputBorder()

            ),

          ),

          const SizedBox(height: 24),

          ElevatedButton(

            onPressed: _saving ? null : _save,

            child: Text(_saving ? "保存中..." : "保存")

          ),

          const Divider(height: 40),

          const Text(
            "说明",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
          ),

          const SizedBox(height: 8),

          const Text(
            "服务器地址用于连接 RealtimeFaceSwap 后端，"
            "默认为本机 127.0.0.1:8000。"
            "如后端运行在其他机器，请填写对应 IP。"
          )

        ]

      )

    );

  }

}
