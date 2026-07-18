import 'package:flutter/material.dart';


class ControlBar extends StatelessWidget {

  const ControlBar({
    super.key
  });

  @override
  Widget build(
    BuildContext context
  ) {

    return Row(

      mainAxisAlignment: MainAxisAlignment.center,

      children: [

        ElevatedButton(

          onPressed: () {},

          child: const Text(
            "开始换脸"
          )

        ),

        const SizedBox(
          width: 20
        ),

        ElevatedButton(

          onPressed: () {},

          child: const Text(
            "模型设置"
          )

        ),

      ],

    );

  }

}
