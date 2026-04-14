import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

class ZitAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const ZitAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      toolbarHeight: 70,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          // menu action later
        },
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/logo.png', height: 40),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
        ),
      ],
    );
  }
}