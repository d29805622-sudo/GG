import 'dart:convert';

import 'package:flutter/material.dart';


class VideoView extends StatelessWidget {

  final Stream<String>? stream;

  const VideoView({
    super.key,
    this.stream
  });

  @override
  Widget build(
    BuildContext context
  ) {

    if (stream == null) {

      return const Center(

        child: Text(
          "点击「启动」开始连接..."
        )

      );

    }

    return StreamBuilder<String>(

      stream: stream,

      builder: (context, snapshot) {

        if (snapshot.hasError) {

          return const Center(

            child: Text(
              "连接错误"
            )

          );

        }

        if (!snapshot.hasData) {

          return const Center(

            child: CircularProgressIndicator()

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

}
