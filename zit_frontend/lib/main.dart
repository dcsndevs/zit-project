import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/product_list_screen.dart';

void main() {
  runApp(const ZitApp());
}

class ZitApp extends StatelessWidget {
  const ZitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZIT SHOP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.orange,
        useMaterial3: true,
      ),
      home: const ProductListScreen(),
    );
  }
}