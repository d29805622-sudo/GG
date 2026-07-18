import 'package:flutter/material.dart';
import 'video_view.dart';

class VideoPanel extends StatelessWidget {
  final Stream<String>? stream;

  const VideoPanel({super.key, this.stream});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8), child: VideoView(stream: stream));
  }
}