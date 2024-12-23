import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/keranjang.dart';
import 'dart:convert'; // For JSON encoding/decoding
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> items = [
    {'id': 1, 'name': 'Macallan 12 Yo Triple Cask', 'price': 3500000},
    {'id': 2, 'name': 'Chivas Regal 18 Yo', 'price': 1200000},
    {'id': 3, 'name': 'Johnnie Walker Blue Label', 'price': 2500000},
  ];

  Future<void> _addToCart(Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> cart = [];

    // Load existing cart from SharedPreferences
    String? cartData = prefs.getString('cart');
    if (cartData != null) {
      cart = List<Map<String, dynamic>>.from(json.decode(cartData));
    }

    // Check if item is already in the cart
    int index = cart.indexWhere((cartItem) => cartItem['id'] == item['id']);
    if (index >= 0) {
      cart[index]['quantity'] += 1;
    } else {
      cart.add({'id': item['id'], 'name': item['name'], 'price': item['price'], 'quantity': 1});
    }

    // Save updated cart back to SharedPreferences
    prefs.setString('cart', json.encode(cart));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item['name']} added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item['name']),
            subtitle: Text('Rp ${item['price']}'),
            trailing: ElevatedButton(
              onPressed: () => _addToCart(item),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
              child: const Text('Add to Cart', style: TextStyle(color: Colors.white)),
            ),
          );
        },
      ),
    );
  }
}
