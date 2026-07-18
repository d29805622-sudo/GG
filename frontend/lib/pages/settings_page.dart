import 'package:flutter/material.dart';
import '../config/server_config.dart';
import '../services/config_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _hostCtrl = TextEditingController();
  final _portCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  @override
  void dispose() {
    _hostCtrl.dispose();
    _portCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadSaved() async {
    await ConfigService.load();
    if (!mounted) return;
    setState(() {
      _hostCtrl.text = ConfigService.serverHost;
      _portCtrl.text = ConfigService.serverPort.toString();
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final data = <String, dynamic>{
      "server_host": _hostCtrl.text.trim().isEmpty
          ? ServerConfig.defaultHost
          : _hostCtrl.text.trim(),
      "server_port":
          int.tryParse(_portCtrl.text.trim()) ?? ServerConfig.defaultPort
    };
    final ok = await ConfigService.save(data);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(ok ? "已保存" : "保存失败")));
    if (ok) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("设置")),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("服务器地址",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextField(
                      controller: _hostCtrl,
                      decoration: const InputDecoration(
                          labelText: "Host",
                          hintText: "例如 192.168.1.100",
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.url),
                  const SizedBox(height: 12),
                  TextField(
                      controller: _portCtrl,
                      decoration: const InputDecoration(
                          labelText: "Port",
                          hintText: "例如 8000",
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 24),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: _saving ? null : _save,
                          child: _saving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2))
                              : const Text("保存"))),
                  const SizedBox(height: 16),
                  const Text("提示：手机与运行后端的电脑需在同一局域网。",
                      style: TextStyle(color: Colors.grey, fontSize: 12))
                ])));
  }
}