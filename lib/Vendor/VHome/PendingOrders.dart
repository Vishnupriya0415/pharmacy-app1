// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/Vendor/Orders/OrderDetails.dart';
import 'package:gangaaramtech/Vendor/Orders/update_order_status.dart';
import 'package:gangaaramtech/Vendor/VHome/Prescription/DetailsScreen.dart';

class PendingDeliveriesScreen extends StatefulWidget {
  const PendingDeliveriesScreen({super.key});

  @override
  _PendingDeliveriesScreenState createState() =>
      _PendingDeliveriesScreenState();
}

class _PendingDeliveriesScreenState extends State<PendingDeliveriesScreen> {
  List<DocumentSnapshot> pendingDeliveries = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    fetchPendingDeliveries();
    _timer = Timer.periodic(const Duration(seconds: 30), (Timer timer) {
      fetchPendingDeliveries();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void fetchPendingDeliveries() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final vendorId = user?.uid;
    final ordersCollection = FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .collection('orders');

    final snapshot = await ordersCollection.where('status',
        whereIn: ['Out for Delivery', 'Accepted', 'Processing']).get();

    setState(() {
      pendingDeliveries = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Pending Deliveries',
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
      body: pendingDeliveries.isEmpty
          ? const Center(
              child: Text('You have no pending deliveries'),
            )
          : ListView.builder(
              itemCount: pendingDeliveries.length,
              itemBuilder: (context, index) {
                final order = pendingDeliveries[index];
                final data = order.data() as Map<String, dynamic>;
                final orderId = order.id;
                final orderStatus = data['status'];
                final medicineNames =
                    (data['medicineNames'] as List?)?.cast<String>();
                final total = data['total'];
                final addressData =
                    data['addressData'] as Map<String, dynamic>?;

                return Card(
                  elevation: 3,
                  color: Colors.grey[150],
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15.0), // Set the border radius
                  ),
                  margin: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Column(
                      children: [
                        Row(
                          children: [
                            Text('Order ID: $orderId'),
                            const Spacer(),
                            Text(" Total cost: ₹$total"),
                          ],
                        ),
                       
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        if (addressData !=
                            null) // Check if addressData is not null
                          Row(
                            children: [
                              Text('Ordered by ${addressData['fullName']}'),
                              const Spacer(),
                              Text('Phone ${addressData['mobileNumber']}'),
                            ],
                          ),
                        Row(
                          children: [
                            Text(
                              'Status: $orderStatus',
                              style: const TextStyle(color: Colors.black),
                            ),
                            const Spacer(),
                            if (order['isPrescription'] == true)
                              const Text(
                                'Prescription order',
                                style: TextStyle(color: Colors.black),
                              )
                            else
                              Text(
                                'Total Medicines: ${medicineNames?.length ?? 0}',
                                style: const TextStyle(color: Colors.black),
                              )
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        const Divider(
                          color:
                              Colors.grey, // Set the color of the divider line
                          thickness: 1, // Set the thickness of the divider line
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (data['isPrescription'] == true) {
                                  // Navigate to the PrescriptionScreen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailsScreen(orderId: orderId),
                                    ),
                                  );
                                } else {
                                  // Navigate to the OrderDetailsScreen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OrderDetailsScreen(orderId: orderId),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue, // Text color
                                padding: const EdgeInsets.all(
                                    10.0), // Button padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Rounded corners
                                ),
                                elevation: 5, // Button shadow
                              ),
                              child: const Text("View Order Details"),
                            ),

                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        VendorOrderStatusScreen(
                                            orderId: orderId),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue, // Text color
                                padding: const EdgeInsets.all(
                                    10.0), // Button padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Rounded corners
                                ),
                                elevation: 5, // Button shadow
                              ),
                              child: const Text('Update Status'),
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
