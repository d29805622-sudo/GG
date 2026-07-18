import 'dart:convert';

import 'package:flutter/material.dart';

import '../services/websocket_service.dart';


class VideoView extends StatefulWidget {

  const VideoView({
    super.key
  });

  @override
  State<VideoView> createState() => _VideoViewState();

}


class _VideoViewState extends State<VideoView> {

  final WebSocketService service = WebSocketService();

  Stream<String>? stream;

  @override
  void initState() {
    super.initState();

    stream = service.connect();
  }

  @override
  Widget build(
    BuildContext context
  ) {

    return StreamBuilder<String>(

      stream: stream,

      builder: (context, snapshot) {

        if (!snapshot.hasData) {

          return const Center(

            child: Text(
              "等待视频连接..."
            )

          );

        }

        return Image.memory(

          base64Decode(
            snapshot.data!
          ),

          fit: BoxFit.contain,

          gaplessPlayback: true,

        );

      },

    );

  }

  @override
  void dispose() {
    service.close();
    super.dispose();
  }

}
