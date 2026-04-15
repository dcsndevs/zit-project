import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/product_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      leading: Builder(
        builder: (ctx) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            showModalBottomSheet(
              context: ctx,
              builder: (_) => SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.home),
                      title: const Text('Home'),
                      onTap: () {
                        Navigator.pop(ctx);
                        Navigator.pushAndRemoveUntil(
                          ctx,
                          MaterialPageRoute(builder: (_) => const ProductListScreen()),
                          (route) => false,
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Profile'),
                      onTap: () async {
                        Navigator.pop(ctx);
                        final prefs = await SharedPreferences.getInstance();
                        final token = prefs.getString('access_token');
                        if (ctx.mounted) {
                          Navigator.push(
                            ctx,
                            MaterialPageRoute(
                              builder: (_) => token != null
                                  ? const ProfileScreen()
                                  : const LoginScreen(),
                            ),
                          );
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: const Text('About'),
                      onTap: () {
                        Navigator.pop(ctx);
                        showDialog(
                          context: ctx,
                          builder: (_) => AlertDialog(
                            title: const Text('ZIT Shop'),
                            content: const Text('Version 1.0.0\n\nYour Nigerian ecommerce generator shop.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },

                    ),
                  ],
                ),
              ),
            );
          },
        ),
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
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            final token = prefs.getString('access_token');
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => token != null
                      ? const ProfileScreen()
                      : const LoginScreen(),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
