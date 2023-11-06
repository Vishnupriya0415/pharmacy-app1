// ignore_for_file: avoid_print, library_private_types_in_public_api, file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/Prescription/OrderPlacing/Prescription_Orde_Placing2/OrderplacingScreen.dart';
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
Future<void> placeOrder(String vendorUid, double cost, String imageUrl,
      Map<String, dynamic> addressData, String OrderID) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userUID = user.uid;
      CollectionReference userOrders = FirebaseFirestore.instance
          .collection('users')
          .doc(userUID)
          .collection('orders');

      try {
        String orderID = OrderID; // Generate the order ID
        DocumentReference orderDocRef = userOrders
            .doc(orderID); // Set the document reference with the order ID

        Map<String, dynamic> orderData = {
          'vendorUid': vendorUid,
          'orderId': orderID,
          'total': cost,
          'imageURL': imageUrl,
          'address': addressData,
          'status':
              'Pending', // You can set the initial status as 'Pending' or any other status you prefer.
          'isPrescription': true, // Adjust this based on your logic
          // Add other order details as needed
        };

        // Store the order data in the user's 'orders' subcollection
        await orderDocRef.set(orderData);

        // Now, store the same order data in the user's main collection within the 'orders' subcollection
        // This is how you can achieve storing it in both places
        DocumentReference userOrderDocRef = FirebaseFirestore.instance
            .collection('vendors')
            .doc(userUID)
            .collection('orders')
            .doc(orderID);
        await userOrderDocRef.set(orderData);

        print('Order placed successfully with ID: $orderID');
      } catch (e) {
        print('Error placing order: $e');
      }
    }
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
String generateOrderID() {
    DateTime now = DateTime.now();
    int random = Random().nextInt(9000) + 1000;
    String orderID =
        'OD${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}$random';
    return orderID;
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
                                    String orderId = generateOrderID();
                                    placeOrder(
                                        orderData['vendorUid'],
                                        // generateOrderID() as double,
                                        orderData['total'].toDouble(),
                                        orderData['imageURL'],
                                        orderData['address'],
                                        orderId);

                                    // Navigate to the OrderPlacingScreen
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrderPlacingScreen(
                                          vendorUid: orderData['vendorUid'],
                                          orderID: orderId,
                                          cost: orderData['total'].toDouble(),
                                          imageUrl: orderData['imageURL'],
                                          addressData: orderData['address'],
                                        ),
                                      ),
                                    );
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
