// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/Vendor/Orders/OrderDetails.dart';
import 'package:gangaaramtech/Vendor/Orders/update_order_status.dart';

class PendingDeliveriesScreen extends StatefulWidget {
  const PendingDeliveriesScreen({super.key});

  @override
  _PendingDeliveriesScreenState createState() =>
      _PendingDeliveriesScreenState();
}

class _PendingDeliveriesScreenState extends State<PendingDeliveriesScreen> {
  // Define a list to store pending deliveries (accepted orders)
  List<DocumentSnapshot> pendingDeliveries = [];
  late Timer _timer; // Declare a Timer variable.

  @override
  void initState() {
    super.initState();
    // Fetch the list of accepted orders from Firestore when the screen loads
    fetchPendingDeliveries();
    _timer = Timer.periodic(const Duration(seconds: 30), (Timer timer) {
      fetchPendingDeliveries();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the screen is disposed to prevent memory leaks.
    _timer.cancel();
    super.dispose();
  }

  void fetchPendingDeliveries() async {
    // Fetch the list of accepted orders from the "orders" subcollection of the vendor
    final User? user = FirebaseAuth.instance.currentUser;
    final vendorId = user?.uid; // Use the user's UID as the vendor ID
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

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      // Update the status of the order in Firestore
      final User? user = FirebaseAuth.instance.currentUser;
      final vendorId = user?.uid; // Use the user's UID as the vendor ID
      final orderRef = FirebaseFirestore.instance
          .collection('vendors')
          .doc(vendorId)
          .collection('orders')
          .doc(orderId);

      // Fetch the order document
      final orderDoc = await orderRef.get();

      if (orderDoc.exists) {
        // Access the userUid from the order document data
        final userUid = orderDoc.data()?['userUid'];

        // Now, you can use the userUid as needed
        print('User UID stored in the order document: $userUid');

        // Update the status
        await orderRef.update({'status': status});

        // Optionally, you can show a success message or perform other actions here.
        // For example, you could show a snackbar indicating the status update was successful.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order status updated to: $status'),
          ),
        );
      } else {
        // Handle the case where the order document does not exist
        print('Order document does not exist');
      }
    } catch (error) {
      // Handle any errors that occur during the update process
      print('Error updating order status: $error');
      // Optionally, you can also show an error message to the user.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating order status: $error'),
        ),
      );
    }
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
                final medicineNames = List<String>.from(data['medicineNames']);
                final total = data['total'];
                final addressData = data['addressData'] as Map<String, dynamic>;
                
                return Card(
                  margin: const EdgeInsets.all(8.0),
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
                        Row(
                          children: [
                            Text('Ordered by ${addressData['fullName']}'),
                            const Spacer(),
                            Text('Phone ${addressData['mobileNumber']}')
                          ],
                        ),
                      ],
                    ),

                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Status: $orderStatus',
                              style: const TextStyle(color: Colors.black),
                            ),
                            const Spacer(),
                            Text(
                              'Total Medicines: ${medicineNames.length}',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        // const Text("Delivery address:"),

                        /* const Align(
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
                        ),*/
                        Row(
                          children: [
                            // Inside your ListView.builder in PendingDeliveriesScreen
                            ElevatedButton(
                              onPressed: () {
                                // Navigate to the OrderDetailsScreen and pass the orderId as a route argument
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
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                // Call the updateOrderStatus method when the button is pressed
                                // Replace 'NewStatus' with the desired status
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        VendorOrderStatusScreen(
                                            orderId: orderId),
                                  ),
                                );
                              },
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
