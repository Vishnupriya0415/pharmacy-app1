import 'package:flutter/material.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Currently Placed Orders'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Add functionality to navigate to the "Currently Placed Orders" page
            },
          ),
          ListTile(
            title: const Text('Recent Orders'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Add functionality to navigate to the "Recent Orders" page
            },
          ),
        ],
      ),
    );
  }
}
