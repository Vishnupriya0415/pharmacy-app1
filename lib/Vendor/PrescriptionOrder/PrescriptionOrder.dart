// ignore_for_file: library_private_types_in_public_api, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gangaaramtech/Vendor/PrescriptionOrder/OrderDetails.dart';

class PrescriptionOrdersPage extends StatefulWidget {
  const PrescriptionOrdersPage({Key? key}) : super(key: key);

  @override
  _PrescriptionOrdersPageState createState() => _PrescriptionOrdersPageState();
}

class _PrescriptionOrdersPageState extends State<PrescriptionOrdersPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentUser != null
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('vendors')
                  .doc(_currentUser!
                      .uid) // Use the current user's ID for the vendor
                  .collection('orders')
                  .where('status', isEqualTo: 'pending')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No pending prescription orders."),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var order = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    String orderID = snapshot.data!.docs[index].id;
                    String imageUrl = order['imageURL'] ??
                        ''; // Get the prescription image URL
                    // Customize the order item UI as needed
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to the OrderDetailsPage when tapped
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => OrderDetailsPage(
                                  orderID: orderID,
                                  imageUrl: imageUrl,
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Column(
                              children: [
                                Text("Order ID: $orderID"),
                              ],
                            ),

                            subtitle: Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: imageUrl.isNotEmpty
                                      ? Image.network(imageUrl)
                                      : Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors
                                              .grey, // You can use any color or widget to indicate no image
                                        ),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  children: [
                                    const Text(" Status:"),
                                    Text(
                                        "Pharmacy Name: ${order['pharmacyName']}"),
                                  ],
                                ),
                              ],
                            ),

                            // Display the prescription image
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
