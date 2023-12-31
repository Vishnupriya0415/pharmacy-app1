// ignore_for_file: library_private_types_in_public_api, unused_local_variable

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gangaaramtech/utils/widgets/Alert_dialog_box.dart';

class VendorOrdersScreen extends StatefulWidget {
  const VendorOrdersScreen({super.key});

  @override
  _VendorOrdersScreenState createState() => _VendorOrdersScreenState();
}

class _VendorOrdersScreenState extends State<VendorOrdersScreen> {
  // Define a list to store orders
  List<DocumentSnapshot> orders = [];
  late Timer _timer; // Declare a Timer variable.
  TextEditingController cancellationReasonController =
      TextEditingController(); // Define it here

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

    final snapshot = await ordersCollection
        .where('status', isEqualTo: 'pending')
        .where('isPrescription', isEqualTo: false)
        .get();

    setState(() {
      orders = snapshot.docs;
    });
  }

  /* Future<void> _showCancellationReasonDialog(String orderId) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Cancellation Reason"),
          content: TextField(
            controller: cancellationReasonController,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Get the cancellation reason text from the controller
                String cancellationReason = cancellationReasonController.text;

                // Close the dialog
                Navigator.of(context).pop();

                // Update the order status with the cancellation reason
                updateOrderStatus(orderId, 'Cancelled', cancellationReason);
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }
*/
  _showCancellationReasonDialog(String orderId) {
    final TextEditingController cancellationReasonController =
        TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return CurvedAlertDialogBox(
          title: "Reason for cancelling the order",
          hintText: 'Enter the cancellation Reason',
          textController: cancellationReasonController,
          onClosePressed: () {
            Navigator.of(context).pop();
          },
          keyboardType: TextInputType.name,
          onSubmitPressed: () {
            String cancellationReason = cancellationReasonController.text;
            // Close the dialog
            Navigator.of(context).pop();
            // Update the order status with the cancellation reason
            updateOrderStatus(orderId, 'Cancelled', cancellationReason);
          },
        );
      },
    );
  }


  DateTime convertTimestampToIST(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final indianTime = dateTime.toLocal(); // Convert to local time (UTC)
    final ist = indianTime.add(const Duration(
        hours: 5, minutes: 30)); // Add 5 hours and 30 minutes to convert to IST
    return ist;
  }

  Future<void> updateOrderStatus(String orderId, String status,
      [String? cancellationReason]) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final vendorId = user?.uid; // Use the user's UID as the vendor ID
    final orderRef = FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .collection('orders')
        .doc(orderId);

    final orderData = await orderRef.get();
    final userUid = orderData.data()!['userUid']; // Accessing 'userUid' field

    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('orders')
        .doc(orderId);

    // Get the current time in UTC
    final currentTimeUtc = DateTime.now().toUtc();

    // Convert UTC time to Indian Standard Time (IST)
    final currentTimeIST =
        currentTimeUtc.add(const Duration(hours: 5, minutes: 30));

    // Define a map to hold the status time updates
    final statusTimeUpdates = <String, dynamic>{};

    if (status == 'Accepted') {
      statusTimeUpdates['acceptedTime'] = DateTime.now();
    } else if (status == 'Processing') {
      statusTimeUpdates['processingTime'] = DateTime.now();
    } else if (status == 'Out for Delivery') {
      statusTimeUpdates['outForDeliveryTime'] = DateTime.now();
    } else if (status == 'Delivered') {
      statusTimeUpdates['deliveredTime'] = DateTime.now();
    } else if (status == 'Cancelled' && cancellationReason != null) {
      statusTimeUpdates['cancellationReason'] = cancellationReason;
      statusTimeUpdates['cancelledTime'] = DateTime.now();
    }

    statusTimeUpdates['status'] = status;

    // Update the order document with the status and status times
    await orderRef.update(statusTimeUpdates);
    await userDocRef.update(statusTimeUpdates);

    // Update the local list of orders
    setState(() {
      orders.removeWhere((order) => order.id == orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                final addressData =
                    data['addressData'] as Map<String, dynamic>?;
                final name = order['address']?['fullName'] ?? '';
                final mobileNumber = order['address']?['mobileNumber'] ?? '';

                return Card(
                  margin: const EdgeInsets.all(15.0),
                  elevation: 5,
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
                        // Text('Status: $orderStatus'),

                        //const Spacer(),
                        /*Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Status: $orderStatus',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),*/

                        Row(
                          children: [
                            Text(
                              'Customer name: $name',
                              style: const TextStyle(color: Colors.black),
                            ),
                            const Spacer(),
                            Text('Phone $mobileNumber',
                                style: const TextStyle(color: Colors.black)),
                          ],
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Medicine Names",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: medicineNames.map((medicineName) {
                              return Text(medicineName,
                                  style: const TextStyle(color: Colors.black));
                            }).toList(),
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _showCancellationReasonDialog(orderId);
                                // Update the status of the order to 'Cancelled'
                                //  updateOrderStatus(orderId, 'Cancelled');
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
                              child: const Text('Cancel'),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                // Update the status of the order to 'Accepted'
                                updateOrderStatus(orderId, 'Accepted');
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
