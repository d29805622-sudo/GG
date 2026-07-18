import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'services/config_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConfigService.load();
  runApp(const FaceSwapApp());
}

class FaceSwapApp extends StatelessWidget {
  const FaceSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "RealtimeFaceSwap",
      theme: ThemeData.dark(useMaterial3: true),
      home: const HomePage()
    );
  }
}