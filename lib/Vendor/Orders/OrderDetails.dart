import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({required this.orderId});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final vendorId = user?.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details  - $orderId'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('vendors')
            .doc(vendorId) // Replace with your vendor ID
            .collection('orders')
            .doc(orderId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Order not found'));
          }

          final orderData = snapshot.data!.data() as Map<String, dynamic>;
          final orderStatus = orderData['status'];
          final medicineNames = List<String>.from(orderData['medicineNames']);
          final total = orderData['total'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order ID: $orderId'),
                Text('Status: $orderStatus'),
                Text('Total cost: ₹$total'),
                const Text('Medicine Names:'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final medicineName in medicineNames)
                      Text(medicineName),
                    Text(
                        'Total Medicines: ${medicineNames.length}'), // Display the total count
                  ],
                ),

                // You can display more order details here
              ],
            ),
          );
        },
      ),
    );
  }
}
