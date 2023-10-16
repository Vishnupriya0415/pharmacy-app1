import 'dart:async';

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

  late Timer _timer; // Declare a Timer variable.

  @override
  void initState() {
    super.initState();
    // Fetch the list of orders from Firestore when the screen loads
    fetchOrders();
    _timer = Timer.periodic(const Duration(seconds: 30), (Timer timer) {
      fetchOrders();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the screen is disposed to prevent memory leaks.
    _timer.cancel();
    super.dispose();
  }

  void fetchOrders() async {
    // Fetch the list of orders from the "orders" subcollection of the vendor
    final User? user = FirebaseAuth.instance.currentUser;
    final vendorId = user?.uid; // Use the user's UID as the vendor ID
    final ordersCollection = FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .collection('orders');

    final snapshot =
        await ordersCollection.where('status', isEqualTo: 'pending').get();

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

  Future<void> updateOrderStatus(
      String orderId, String status, String? cancellationReason) async {
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
    } else if (status == 'Cancelled') {
      // If the status is 'Cancelled', update the order status and store the reason
      await orderRef.update({
        'status': status,
        'cancellationReason': cancellationReason,
      });
    }

    // Remove the canceled order from the list
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
                final addressData = data['addressData'] as Map<String, dynamic>;
               
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(20.0),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text('Order ID: $orderId'),
                        
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Text('Status: $orderStatus'),
                            const Spacer(),
                            Text(" Total cost : ₹$total"),
                          ],
                        ),
                        Text(
                            'Address: ${addressData['doorNo']}, ${addressData['street']},  ${addressData['landmark']},${addressData['city']}, ${addressData['state']}, ${addressData['postalCode']}'),
                        /* const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Medicine Names",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),*/
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Number of Medicines: ${medicineNames.length}'),
                            ],
                          ),
                        ),

                        /* Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: medicineNames.map((medicineName) {
                              return Text(medicineName);
                            }).toList(),
                          ),
                        ),*/
                      
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Prompt the user to enter a cancellation reason.
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String reason =
                                        ''; // Initialize the cancellation reason
                                    return AlertDialog(
                                      title: const Text(
                                          'Enter Cancellation Reason'),
                                      content: TextField(
                                        onChanged: (value) {
                                          reason =
                                              value; // Update the reason as the user types
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            updateOrderStatus(
                                                orderId, 'Cancelled', reason);
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: const Text('Confirm'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Cancel'),
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                // Update the status of the order to 'Accepted'
                                updateOrderStatus(orderId, 'Accepted', null);
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Accept'),
                              ),
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
