import 'package:flutter/material.dart';

import 'pages/home_page.dart';


void main() {
  runApp(
    const FaceSwapApp()
  );
}


class FaceSwapApp extends StatelessWidget {

  const FaceSwapApp({
    super.key
  });

  @override
  Widget build(
    BuildContext context
  ) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: "RealtimeFaceSwap",

      theme: ThemeData.dark(),

      home: const HomePage(),

    );
  }
}
