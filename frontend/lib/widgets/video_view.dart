import 'dart:convert';
import 'package:flutter/material.dart';

class VideoView extends StatefulWidget {
  final Stream<String>? stream;

  const VideoView({super.key, this.stream});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  @override
  Widget build(BuildContext context) {
    final stream = widget.stream;
    if (stream == null) {
      return Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: const Text("未连接", style: TextStyle(color: Colors.white54)));
    }

    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(
                color: Colors.black,
                alignment: Alignment.center,
                child:
                    const Text("连接错误", style: TextStyle(color: Colors.red)));
          }
          if (!snapshot.hasData) {
            return Container(
                color: Colors.black,
                alignment: Alignment.center,
                child: const CircularProgressIndicator());
          }
          try {
            final bytes = base64Decode(snapshot.data!);
            return Image.memory(bytes,
                fit: BoxFit.contain, gaplessPlayback: true);
          } catch (_) {
            return Container(
                color: Colors.black,
                alignment: Alignment.center,
                child: const Text("解码失败",
                    style: TextStyle(color: Colors.orange)));
          }
        });
  }
}