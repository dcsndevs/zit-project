import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../widgets/zit_app_bar.dart';
import 'product_list_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _apiService = ApiService();
  Map<String, dynamic>? _profile;
  List<dynamic> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadOrders();
  }

  void _loadProfile() async {
    try {
      final token = await _apiService.getToken();
      final response = await _apiService.getProfile(token!);
      setState(() {
        _profile = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _loadOrders() async {
    try {
      final orders = await _apiService.getOrders();
      setState(() => _orders = orders);
    } catch (e) {
      // no orders or not authenticated
    }
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ProductListScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ZitAppBar(title: 'Profile'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Username: ${_profile?['username']}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 12),
                  Text('Email: ${_profile?['email']}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 24),
                  const Text('Order History',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _orders.isEmpty
                        ? const Text('No orders yet',
                            style: TextStyle(color: Colors.grey))
                        : ListView.builder(
                            itemCount: _orders.length,
                            itemBuilder: (context, index) {
                              final order = _orders[index];
                              return Card(
                                child: ListTile(
                                  title: Text('ZIT${order['id'].toString().padLeft(4, '0')}'),
                                  subtitle: Text(order['created_at'].toString().substring(0, 10)),
                                  trailing: Text('₦${order['total_price'].toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},')}'),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Logout', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
