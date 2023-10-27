// ignore_for_file: unnecessary_null_comparison, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gangaaramtech/Vendor/Orders/OrderDetails.dart';

class DeliveredOrdersScreen extends StatefulWidget {
  const DeliveredOrdersScreen({Key? key}) : super(key: key);

  @override
  _DeliveredOrdersScreenState createState() => _DeliveredOrdersScreenState();
}

class _DeliveredOrdersScreenState extends State<DeliveredOrdersScreen> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> deliveredOrders = [];

  @override
  void initState() {
    super.initState();
    fetchDeliveredOrders();
  }

  void fetchDeliveredOrders() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final vendorId = user?.uid;
      final ordersCollection = FirebaseFirestore.instance
          .collection('vendors')
          .doc(vendorId)
          .collection('orders');

      final snapshot = await ordersCollection
          .where('status', isEqualTo: 'Delivered')
          .get();

      setState(() {
        deliveredOrders = snapshot.docs;
      });
    } catch (error) {
      print('Error fetching delivered orders: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Delivered Orders',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ), // Use appropriate icon for back arrow
          onPressed: () {
            Navigator.pop(
                context); // Go back to the previous screen on arrow button press
          },
        ),
      ),
      body: deliveredOrders.isEmpty
          ? const Center(
              child: Text('You have no delivered orders'),
            )
          : ListView.builder(
              itemCount: deliveredOrders.length,
              itemBuilder: (context, index) {
                final order = deliveredOrders[index].data();
                final orderId = deliveredOrders[index].id;

                if (order != null) {
                  // Check if order is not null
                  final orderStatus = order['status'];
                  final addressData = order['addressData'];
                  final total = order['total'];

                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Row(
                        children: [
                          Text('Order ID: $orderId'),
                          const Spacer(),
                          Text(" Total cost: ₹$total"),
                        ],
                      ),
                      subtitle: Column(
                        children: [
                          if (addressData != null)
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                        'Ordered by ${addressData['fullName']}'),
                                    const Spacer(),
                                    Text('Phone ${addressData['mobileNumber']}')
                                  ],
                                ),
                              ],
                            ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Status: $orderStatus'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OrderDetailsScreen(orderId: orderId),
                                ),
                              );
                            },
                            child: const Text("View Order Details"),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const SizedBox
                      .shrink(); // Skip rendering this item if order is null
                }
              },
            ),
    );
  }
}
