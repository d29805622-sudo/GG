import 'package:flutter/material.dart';

import 'video_view.dart';


class VideoPanel extends StatelessWidget {

  const VideoPanel({
    super.key
  });

  @override
  Widget build(
    BuildContext context
  ) {

    return Container(

      padding: const EdgeInsets.all(10),

      child: const VideoView(),

    );

  }

}
