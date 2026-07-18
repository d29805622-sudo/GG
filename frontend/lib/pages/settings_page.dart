import 'package:flutter/material.dart';


class SettingsPage extends StatelessWidget {

  const SettingsPage({
    super.key
  });

  @override
  Widget build(
    BuildContext context
  ) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "软件设置"
        )

      ),

      body: ListView(

        children: [

          SwitchListTile(

            title: const Text(
              "GPU加速"
            ),

            value: true,

            onChanged: (v) {},

          ),

          ListTile(

            title: const Text(
              "摄像头选择"
            ),

            subtitle: const Text(
              "默认摄像头"
            ),

          ),

          ListTile(

            title: const Text(
              "AI模型"
            ),

            subtitle: const Text(
              "default"
            ),

          )

        ]

      )

    );

  }

}
