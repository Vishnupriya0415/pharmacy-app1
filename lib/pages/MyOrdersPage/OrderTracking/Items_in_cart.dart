// ignore_for_file: use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';
import 'package:gangaaramtech/pages/cart/CartProvider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return ListView.builder(
            itemCount: cartProvider.cartItems.length,
            itemBuilder: (context, index) {
              final cartItem = cartProvider.cartItems[index];
              return ListTile(
                title: Text(cartItem.medicineName),
                subtitle: Text('Quantity: ${cartItem.quantity}'),
                trailing: Text('Price: ₹${cartItem.cost.toStringAsFixed(2)}'),
              );
            },
          );
        },
      ),
    );
  }
}
