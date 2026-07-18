import 'package:flutter/material.dart';

class StatusPanel extends StatelessWidget {
  final Map<String, dynamic>? status;
  final String host;
  final int port;

  const StatusPanel(
      {super.key, this.status, required this.host, required this.port});

  String _fmt(dynamic v, String def) => v == null ? def : v.toString();

  Widget item(String name, String value) {
    return Card(
        child: ListTile(
            dense: true,
            title: Text(name),
            trailing:
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold))));
  }

  @override
  Widget build(BuildContext context) {
    final s = status ?? {};
    return Column(children: [
      item("服务器", "$host:$port"),
      item("运行状态", s["running"] == true ? "运行中" : "已停止"),
      item("FPS", _fmt(s["fps"], "--")),
      item("检测人脸", _fmt(s["faces"], "--")),
      item("延迟(ms)", _fmt(s["latency_ms"], "--")),
      item("GPU加速", s["gpu_enabled"] == true ? "已启用" : "未启用"),
      item("分辨率", _fmt(s["resolution"], "--"))
    ]);
  }
}