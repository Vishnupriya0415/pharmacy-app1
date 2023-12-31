// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/OrderDetailsScreen.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/OrderTrackingPage.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/Prescription/OrderPlacing/Prescription_Orde_Placing2/PrescriptionOrderDetailsScreen.dart';

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

          final documents = snapshot.data!.docs;
          List<DocumentSnapshot> filteredOrders = documents.where((document) {
            final orderData = document.data() as Map<String, dynamic>;
            final status = orderData['status'];
            // Filter orders with specific statuses
            return status == 'Processing' ||
                status == 'pending' ||
                status == 'Accepted' ||
                status == 'Out for Delivery';
          }).toList();

          // Reverse the order of the filteredOrders list to display newest orders on top
          filteredOrders = filteredOrders.reversed.toList();

          if (filteredOrders.isEmpty) {
            return const Center(
              child: Text('No orders found with selected statuses.'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: filteredOrders.map((DocumentSnapshot document) {
                    Map<String, dynamic> orderData =
                        document.data() as Map<String, dynamic>;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        color: Colors.grey[150],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              15.0), // Set the border radius
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: ListTile(
                            title: Text('Order ID: ${orderData['orderId']}'),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(" Total : ₹${orderData['total']}"),
                                    const Spacer(),
                                    Text('Status: ${orderData['status']}'),
                                    //   Text(
                                    //     'Is Prescription: ${orderData['isPrescription'].toString()}')

                                  ],
                                ),
                               
                                Row(
                                  children: [
                                    if (orderData['isPrescription'] != null &&
                                        !orderData['isPrescription'])
                                      Text(
                                          "No of medicines: ${orderData['medicineNames']?.length ?? 0}")
                                    else
                                      const Text("Prescription order"),
                                    const Spacer(),
                                    Text(
                                        "${orderData['pharmacyName'] ?? ''}"), // Handle potential null value
                                  ],
                                ),


                                const SizedBox(
                                  height: 3,
                                ),
                                const Divider(
                                  color: Colors.black,
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                       onPressed: () {
                                        // Pass the order ID from the orderData to the UserOrderTrackingScreen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OrderTrackingPage(
                                                    orderId:
                                                        orderData['orderId']),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            Colors.blue, // Text color
                                        padding: const EdgeInsets.all(
                                            10.0), // Button padding
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10), // Rounded corners
                                        ),
                                        elevation: 5, // Button shadow
                                      ),
                                      child: const Text('Track Order'),
                                    ),
                                    const Spacer(),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (orderData['isPrescription']) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PrescriptionOrderDetailsScreen(
                                                orderId: orderData['orderId'],
                                                // Replace with the actual field name in your data
                                              ),
                                            ),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UserOrderDetailsScreen(
                                                orderId: orderData['orderId'],
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            Colors.blue, // Text color
                                        padding: const EdgeInsets.all(
                                            10.0), // Button padding
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10), // Rounded corners
                                        ),
                                        elevation: 5, // Button shadow
                                      ),
                                      child: const Text('View order details'),
                                    )

                                  ],
                                ),
                              ],
                            ),
                            // Rest of your code
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              
            ],
          );
        },
      ),
    );
  }
}
