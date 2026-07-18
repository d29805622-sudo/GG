import 'package:flutter/material.dart';


class StatusPanel extends StatelessWidget {

  final Map<String, dynamic> status;

  final String host;

  final int port;

  const StatusPanel({
    super.key,
    required this.status,
    required this.host,
    required this.port
  });

  Widget item(
    String name,
    String value
  ) {

    return Card(

      child: ListTile(

        title: Text(name),

        trailing: Text(value),

      ),

    );

  }

  String _fmt(dynamic v, String fallback) {

    if (v == null) return fallback;

    return v.toString();

  }

  @override
  Widget build(
    BuildContext context
  ) {

    return Column(

      children: [

        item(
          "服务器",
          "$host:$port"
        ),

        item(
          "运行状态",
          status["running"] == true ? "运行中" : "已停止"
        ),

        item(
          "FPS",
          _fmt(status["fps"], "--")
        ),

        item(
          "检测人脸",
          _fmt(status["faces"], "--")
        ),

        item(
          "延迟(ms)",
          _fmt(status["latency_ms"], "--")
        ),

        item(
          "GPU加速",
          status["gpu_enabled"] == true ? "已启用" : "未启用"
        ),

        item(
          "分辨率",
          _fmt(status["resolution"], "--")
        )

      ],

    );

  }

}
