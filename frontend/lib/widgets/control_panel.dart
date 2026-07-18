import 'package:flutter/material.dart';


class ControlPanel extends StatelessWidget {

  final bool running;

  final VoidCallback onStart;

  final VoidCallback onStop;

  final VoidCallback onSettings;

  const ControlPanel({
    super.key,
    required this.running,
    required this.onStart,
    required this.onStop,
    required this.onSettings
  });

  @override
  Widget build(
    BuildContext context
  ) {

    return Row(

      mainAxisAlignment: MainAxisAlignment.center,

      children: [

        ElevatedButton(

          onPressed: running ? null : onStart,

          child: const Text("启动")

        ),

        const SizedBox(width: 20),

        ElevatedButton(

          onPressed: running ? onStop : null,

          child: const Text("停止")

        ),

        const SizedBox(width: 20),

        ElevatedButton(

          onPressed: onSettings,

          child: const Text("设置")

        ),

      ],

    );

  }

}
