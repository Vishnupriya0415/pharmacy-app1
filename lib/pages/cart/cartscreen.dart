import 'package:flutter/material.dart';

class CartItem {
  final String medicineName;
  final String dosage;
  final String tablets;
  final String description;
  final String shippingMethod;
  final String cost;
  final List<String> imagePaths;

  CartItem({
    required this.medicineName,
    required this.dosage,
    required this.tablets,
    required this.description,
    required this.shippingMethod,
    required this.cost,
    required this.imagePaths,
  });
}

class Cart {
  List<CartItem> items = [];

  void addItem(CartItem item) {
    items.add(item);
  }

  void removeItem(CartItem item) {
    items.remove(item);
  }
}

class CartScreen extends StatelessWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (context, index) {
          CartItem cartItem = cart.items[index];
          return ListTile(
            leading:
                Image.asset(cartItem.imagePaths[0]), // Display the first image
            title: Text(cartItem.medicineName),
            subtitle: Text('Quantity: ${cartItem.tablets}'),
            trailing: Text('Cost: ${cartItem.cost}'),
          );
        },
      ),
    );
  }
}
