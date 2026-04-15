import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/zit_app_bar.dart';
import 'checkout_screen.dart';


class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _apiService = ApiService();
  List<dynamic> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    try {
      final products = await _apiService.getProducts();
      print(products); //print
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Catalogue')),
      appBar: const ZitAppBar(title: 'All Products'),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: product['image_url'] != null && product['image_url'] != ''
                        ? GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  child: Image.network(
                                    product['image_url'],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            },
                            child: Image.network(
                              product['image_url'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image_not_supported),
                            ),
                          )
                        : const Icon(Icons.image_not_supported),

                    title: Text(product['name']),
                    subtitle: Text(product['description']),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('₦${int.parse(double.parse(product['price'].toString()).round().toString()).toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},')}'),
                        const SizedBox(height: 4),
                        SizedBox(
                          height: 24,
                          child: product['stock'] != null && product['stock'] > 0
                              ? ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CheckoutScreen(product: product),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    textStyle: const TextStyle(fontSize: 11),
                                  ),
                                  child: const Text('Buy'),
                                )
                              : const Text(
                                  'Out of Stock',
                                  style: TextStyle(color: Colors.red, fontSize: 11),
                                ),
                        ),

                      ],
                    ),
                  ),
                );

              },

            ),
    );
  }
}