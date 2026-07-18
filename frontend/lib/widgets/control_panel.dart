import 'package:flutter/material.dart';


class ControlPanel extends StatelessWidget {

  const ControlPanel({
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
            "启动"
          )

        ),

        const SizedBox(
          width: 20
        ),

        ElevatedButton(

          onPressed: () {},

          child: const Text(
            "停止"
          )

        ),

        const SizedBox(
          width: 20
        ),

        ElevatedButton(

          onPressed: () {},

          child: const Text(
            "设置"
          )

        ),

      ],

    );

  }

}
