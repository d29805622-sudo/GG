import 'package:flutter/material.dart';


class AboutPage extends StatelessWidget {

  const AboutPage({
    super.key
  });

  @override
  Widget build(
    BuildContext context
  ) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "关于"
        )

      ),

      body: const Center(

        child: Text(

          "RealtimeFaceSwap\n\nVersion 1.0.0"

        )

      )

    );

  }

}
