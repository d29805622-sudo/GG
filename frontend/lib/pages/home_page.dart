import 'package:flutter/material.dart';

import '../widgets/video_panel.dart';
import '../widgets/status_panel.dart';
import '../widgets/control_panel.dart';


class HomePage extends StatelessWidget {

  const HomePage({
    super.key
  });

  @override
  Widget build(
    BuildContext context
  ) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "RealtimeFaceSwap v1.1"
        ),

      ),

      body: Row(

        children: [

          Expanded(

            flex: 3,

            child: const VideoPanel()

          ),

          Expanded(

            flex: 1,

            child: Column(

              children: [

                const StatusPanel(),

                const Spacer(),

                const ControlPanel(),

                const SizedBox(
                  height: 20
                )

              ]

            )

          )

        ],

      ),

    );

  }

}
