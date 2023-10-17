import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/OrderTrackingScreen.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/OrderDetailsScreen.dart';

class CurrentOrdersScreen extends StatefulWidget {
  const CurrentOrdersScreen({Key? key});

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

          final filteredOrders = snapshot.data!.docs.where((document) {
            final orderData = document.data() as Map<String, dynamic>;
            final status = orderData['status'];
            // Filter orders with specific statuses
            return status == 'Processing' ||
                status == 'pending' ||
                status == 'Accepted' ||
                status == 'Out for Delivery';
          }).toList();

          if (filteredOrders.isEmpty) {
            return const Center(
              child: Text('No orders found with selected statuses.'),
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
                          const Spacer(),
                          Text(" Total : ₹${orderData['total']}")
                        ],
                      ),
                      subtitle: Column(
                        children: [
                         
                          Row(
                            children: [
                              Text(
                                  " No of medicines: ${orderData['medicineNames'].length}"),
                              const Spacer(),
                              Text('Status: ${orderData['status']}'),
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
                                  String statusString = orderData['status'];
                                  Status status = stringToStatus(statusString);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OrderTracker1(status: status),
                                    ),
                                  );
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
                                            )
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
