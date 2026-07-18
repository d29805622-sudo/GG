import 'package:flutter/material.dart';


class MonitorPage extends StatelessWidget {

  const MonitorPage({
    super.key
  });

  @override
  Widget build(
    BuildContext context
  ) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "性能监控"
        )

      ),

      body: const Column(

        children: [

          Text(
            "FPS: --"
          ),

          Text(
            "GPU: --"
          ),

          Text(
            "延迟: --"
          )

        ]

      )

    );

  }

}
