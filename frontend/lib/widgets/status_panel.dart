import 'package:flutter/material.dart';


class StatusPanel extends StatelessWidget {

  const StatusPanel({
    super.key
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

  @override
  Widget build(
    BuildContext context
  ) {

    return Column(

      children: [

        item(
          "FPS",
          "60"
        ),

        item(
          "GPU",
          "Enabled"
        ),

        item(
          "Camera",
          "Connected"
        )

      ],

    );

  }

}
