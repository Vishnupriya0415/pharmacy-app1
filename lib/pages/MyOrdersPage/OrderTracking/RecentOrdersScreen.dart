// ignore_for_file: avoid_print, library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/Prescription/OrderPlacing/Prescription_Orde_Placing2/PrescriptionOrderDetailsScreen.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/UserOrderDetailsScreen.dart';
import 'package:gangaaramtech/pages/cart/CartItemsPage.dart';

class RecentOrdersScreen extends StatefulWidget {
  const RecentOrdersScreen({super.key});

  @override
  _RecentOrdersScreenState createState() => _RecentOrdersScreenState();
}

class _RecentOrdersScreenState extends State<RecentOrdersScreen> {
  Stream<QuerySnapshot>? ordersStream;

  @override
  void initState() {
    super.initState();
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

            return status == 'Delivered';
          }).toList();

          if (filteredOrders.isEmpty) {
            return const Center(
              child: Text('No recent orders which are delivered.'),
            );
          }

          return ListView(
            children: filteredOrders.map((DocumentSnapshot document) {
              Map<String, dynamic> orderData =
                  document.data() as Map<String, dynamic>;

              final pharmacyName = orderData['pharmacyName'];

              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  elevation: 5,
                  color: Colors.grey[150],
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15.0), // Set the border radius
                  ),
                  //  elevatiofn: 5,
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
                              if (!orderData['isPrescription'])
                                Text(
                                    "No of medicines: ${orderData['medicineNames']?.length ?? 0}"),
                              const Spacer(),
                              Text("${orderData['pharmacyName']}"),
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
                                child: const Text('View order details'),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  if (!orderData['isPrescription']) {
                                    final medicinesList =
                                        (orderData['medicineNames']
                                                as List<dynamic>)
                                            .cast<String>();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CartItemsPage(
                                          cartMedicineList: medicinesList,
                                          pharmacyName: pharmacyName,
                                          vendorUid: orderData['vendorUid'],
                                        ),
                                      ),
                                    );
                                  } else {
                                    // Handle the case where it's a prescription order
                                    // You can add code to display a message or handle this case accordingly
                                    //Also provide functionality to reorder the prescription order
                                  }
                                },
                                child: const Text('Reorder'),
                              )
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
