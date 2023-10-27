// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/UserOrderDetailsScreen.dart';

class CancelOrdersScreen extends StatefulWidget {
  const CancelOrdersScreen({Key? key});

  @override
  _CancelOrdersScreenState createState() => _CancelOrdersScreenState();
}

class _CancelOrdersScreenState extends State<CancelOrdersScreen> {
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

          final filteredOrders = snapshot.data!.docs.where((document) {
            final orderData = document.data() as Map<String, dynamic>;
            final status = orderData['status'];
            // Filter orders with the "Delivered" status
            return status == 'Cancelled';
          }).toList();

          if (filteredOrders.isEmpty) {
            return const Center(
              child: Text('No orders has been cancelled'),
            );
          }

          return ListView(
            children: filteredOrders.map((DocumentSnapshot document) {
              Map<String, dynamic> orderData =
                  document.data() as Map<String, dynamic>;

              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  elevation: 5,
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
                      title: Row(
                        children: [
                          Text('Order ID: ${orderData['orderId']}'),
                        ],
                      ),
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              Text(" Total : ₹${orderData['total']}"),
                              const Spacer(),
                              Text('Status: ${orderData['status']}'),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                  " No of medicines: ${orderData['medicineNames'].length}"),
                              const Spacer(),
                              Text("${orderData['pharmacyName']}"),
                            ],
                          ),
                          Text(
                              " Your order is cancelled by pharmacy because : ${orderData['cancellationReason']}"),
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
                                onPressed: orderData['status'] == 'Cancelled'
                                    ? null
                                    : () {
                                      
                                      },
                                child: const Text('Track Order'),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserOrderDetailsScreen(
                                        orderId: orderData['orderId'],
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('View order details'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
