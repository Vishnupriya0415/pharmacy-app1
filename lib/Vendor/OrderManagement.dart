// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorOrdersScreen extends StatefulWidget {
  const VendorOrdersScreen({super.key});

  @override
  _VendorOrdersScreenState createState() => _VendorOrdersScreenState();
}

class _VendorOrdersScreenState extends State<VendorOrdersScreen> {
  // Define a list to store orders
  List<DocumentSnapshot> orders = [];

  @override
  void initState() {
    super.initState();
    // Fetch the list of orders from Firestore when the screen loads
    fetchOrders();
  }

  void fetchOrders() async {
    // Fetch the list of orders from the "orders" subcollection of the vendor
    final User? user = FirebaseAuth.instance.currentUser;
    final vendorId = user?.uid; // Use the user's UID as the vendor ID
    final ordersCollection = FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .collection('orders');

    final snapshot = await ordersCollection.get();

    setState(() {
      orders = snapshot.docs;
    });
  }

  DateTime convertTimestampToIST(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final indianTime = dateTime.toLocal(); // Convert to local time (UTC)
    final ist = indianTime.add(const Duration(
        hours: 5, minutes: 30)); // Add 5 hours and 30 minutes to convert to IST
    return ist;
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    // Update the status of the order in Firestore
    final User? user = FirebaseAuth.instance.currentUser;
    final vendorId = user?.uid; // Use the user's UID as the vendor ID
    final orderRef = FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .collection('orders')
        .doc(orderId);
    if (status == 'Accepted') {
      // If the status is 'Accepted', update the order status and time
      final acceptedTime = convertTimestampToIST(Timestamp.now());
      await orderRef.update({
        'status': status,
        'acceptedTime': acceptedTime,
      });
    }
    await orderRef.update({'status': status});

    // Remove the cancelled order from the list
    setState(() {
      orders.removeWhere((order) => order.id == orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Orders',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text('You have no incoming orders'),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final data = order.data() as Map<String, dynamic>;
                final orderId = order.id;
                final orderStatus = data['status'];
                final medicineNames = List<String>.from(data['medicineNames']);
                final total = data['total'];

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text('Order ID: $orderId'),
                        const Spacer(),
                        Text(" Total cost : ₹$total"),
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        Text('Status: $orderStatus'),
                        const Text("Delivery address:"),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Medicine Names",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: medicineNames.map((medicineName) {
                              return Text(medicineName);
                            }).toList(),
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Update the status of the order to 'Cancelled'
                                updateOrderStatus(orderId, 'Cancelled');
                              },
                              child: const Text('Cancel'),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                // Update the status of the order to 'Accepted'
                                updateOrderStatus(orderId, 'Accepted');
                              },
                              child: const Text('Accept'),
                            ),
                          ],
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
