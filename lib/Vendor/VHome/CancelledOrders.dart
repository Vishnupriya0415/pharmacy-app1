// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CancelledOrdersScreen extends StatefulWidget {
  const CancelledOrdersScreen({Key? key}) : super(key: key);

  @override
  _CancelledOrdersScreenState createState() => _CancelledOrdersScreenState();
}

class _CancelledOrdersScreenState extends State<CancelledOrdersScreen> {
  List<DocumentSnapshot> cancelledOrders = [];

  @override
  void initState() {
    super.initState();
    fetchCancelledOrders();
  }

  void fetchCancelledOrders() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final vendorId = user?.uid;
    final ordersCollection = FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .collection('orders');

    final snapshot =
        await ordersCollection.where('status', isEqualTo: 'Cancelled').get();

    setState(() {
      cancelledOrders = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Cancelled Orders',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: cancelledOrders.isEmpty
          ? const Center(
              child: Text('No cancelled orders available.'),
            )
          : ListView.builder(
              itemCount: cancelledOrders.length,
              itemBuilder: (context, index) {
                final order = cancelledOrders[index];
                final data = order.data() as Map<String, dynamic>;
                final orderId = order.id;
                //  final orderStatus = data['status'];
                final medicineNames = List<String>.from(data['medicineNames']);
                final quantities = List<int>.from(data['quantity']);
                final total = data['total'];
               
                final cancellationReason = data['cancellationReason'];

                return Card(
                  elevation: 3,
                  color: Colors.grey[150],
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15.0), // Set the border radius
                  ),
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text('Order ID: $orderId'),
                            const Spacer(),
                            Text(" Total cost: ₹$total"),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        //   Text('Status: $orderStatus'),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Cancellation Reason: $cancellationReason',
                              style: const TextStyle(color: Colors.black),
                            )),
                        //  const Text("Delivery address:"),
                        const Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Medicine Names",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            Spacer(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Qty",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: medicineNames.map((medicineName) {
                                  return Text(medicineName);
                                }).toList(),
                              ),
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: quantities.map((quantity) {
                                  return Text(quantity
                                      .toString()); // Convert the integer to a string
                                }).toList(),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
