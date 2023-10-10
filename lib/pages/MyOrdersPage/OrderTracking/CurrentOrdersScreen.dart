// ignore_for_file: library_private_types_in_public_api, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrentOrdersScreen extends StatefulWidget {
  const CurrentOrdersScreen({super.key});

  @override
  _CurrentOrdersScreenState createState() => _CurrentOrdersScreenState();
}

class _CurrentOrdersScreenState extends State<CurrentOrdersScreen> {
  Stream<QuerySnapshot>? ordersStream;

  @override
  void initState() {
    super.initState();
    // Initialize the stream to fetch user orders when the widget is created
    ordersStream = fetchUserOrders();
  }

  Stream<QuerySnapshot> fetchUserOrders() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userUID = user.uid;
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userUID)
          .collection('orders')
          .snapshots();
    } else {
      // Return an empty stream if no user is authenticated
      return const Stream.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: ordersStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No orders found.'),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> orderData =
                  document.data() as Map<String, dynamic>;

              // Create widgets to display order details (e.g., order ID, status, etc.)
              // Customize the UI as needed based on your order data structure.

              return Container(
                child: ListTile(
                  title: Row(
                    children: [
                      Text('Order ID: ${orderData['orderId']}'),
                      const Spacer(),
                      Text(" Total : ₹${orderData['total']}")
                    ],
                  ),
                  subtitle: Column(
                    children: [
                      Text('Status: ${orderData['status']}'),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Handle tracking order button click here
                              // You can navigate to a tracking screen or show order tracking information
                              // for the selected order.
                            },
                            child: const Text('Track Order'),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              
                            },
                            child: const Text('View order details'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Add more widgets to display other order details
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
