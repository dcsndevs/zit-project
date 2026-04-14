import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {

  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // --- AUTH ---
  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', data['access']);
      await prefs.setString('refresh_token', data['refresh']);
      return true;
    }
    return false;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // --- PRODUCTS ---
  Future<List<dynamic>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products/'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load products');
  }

  Future<Map<String, dynamic>> getProduct(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id/'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load product');
  }

  // --- ORDERS ---
  Future<List<dynamic>> getOrders() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/orders/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load orders');
  }

  Future<Map<String, dynamic>> createOrder(
      double totalPrice, List<Map<String, dynamic>> items) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/orders/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'total_price': totalPrice,
        'items': items, // e.g. [{'product': 1, 'quantity': 2}]
      }),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to create order');
  }
}