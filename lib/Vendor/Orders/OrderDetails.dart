import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

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
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Order not found'));
          }

          final orderData = snapshot.data!.data() as Map<String, dynamic>;
          final orderStatus = orderData['status'];
          final medicineNames = List<String>.from(orderData['medicineNames']);
          final quantity = List<int>.from(orderData['quantity']);
          final total = orderData['total'];
          final addressData = orderData['addressData'] as Map<String, dynamic>;
          final cost = List<double>.from(orderData['cost']);

          return Card(
            elevation: 5,
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order ID: $orderId'),
                  Row(
                    children: [
                      Text('Ordered by ${addressData['fullName']}'),
                      const Spacer(),
                      Text('Phone ${addressData['mobileNumber']}')
                    ],
                  ),
                  Row(
                    children: [
                      Text('Status: $orderStatus'),
                      const Spacer(),
                      Text('Total cost: ₹$total'),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Container(
                          width: 200,
                          child: const Text(
                            'Medicine Names:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      const Text(
                        " Qty:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      const Text(
                        " Cost :",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final medicineName in medicineNames)
                            Container(width: 205, child: Text(medicineName)),
                          // Display the total count
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final qty in quantity)
                            Text(qty
                                .toString()), // Convert the integer to a string
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final cost in cost)
                            Text(cost
                                .toString()), // Convert the integer to a string
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('Total No of  Medicines: ${medicineNames.length}'),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    ' Delivery Address:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                      'Address: ${addressData['doorNo']}, ${addressData['street']},  ${addressData['landmark']},${addressData['city']}, ${addressData['state']}, ${addressData['postalCode']}'),
          
                  // You can display more order details here
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
