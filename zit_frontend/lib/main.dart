import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const ZitApp());
}

class ZitApp extends StatelessWidget {
  const ZitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZIT',
      theme: ThemeData(
        colorSchemeSeed: Colors.orange,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}