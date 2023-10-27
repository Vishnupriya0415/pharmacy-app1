// ignore_for_file: no_logic_in_create_state, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailsPage1 extends StatefulWidget {
  final String orderID;
  final String imageUrl;

  const OrderDetailsPage1({super.key, 
    required this.orderID,
    required this.imageUrl,
  });

  @override
  _OrderDetailsPage1State createState() => _OrderDetailsPage1State(orderID);
}

class _OrderDetailsPage1State extends State<OrderDetailsPage1> {
  final String orderID;
  double? totalPrice;
  bool isProcessing = false;

  _OrderDetailsPage1State(this.orderID);

  @override
  void initState() {
    super.initState();
    fetchTotalPrice();
  }

  Future<void> fetchTotalPrice() async {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    String? userUID = user?.uid;

    if (userUID != null) {
      DocumentSnapshot orderSnapshot = await firestore
          .collection('vendors')
          .doc(userUID)
          .collection('orders')
          .doc(orderID)
          .get();

      if (orderSnapshot.exists) {
        Map<String, dynamic> orderData =
            orderSnapshot.data() as Map<String, dynamic>;

        // Check if 'total' exists in the orderData
        if (orderData.containsKey('total')) {
          double fetchedTotal = orderData['total'];
          setState(() {
            totalPrice = fetchedTotal;
          });
        }

        // Check if the order is being processed
        if (orderData.containsKey('pending') && orderData['pending'] == true) {
          setState(() {
            isProcessing = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Order ID: ${widget.orderID}"),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 400,
              child: PhotoView(
                imageProvider: NetworkImage(widget.imageUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                backgroundDecoration: const BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ),
            if (totalPrice != null)
              Text("Total Price: \$${totalPrice!.toStringAsFixed(2)}"),
            if (totalPrice == null)
              const Text("Vendor is processing the order request."),
          ],
        ),
      ),
    );
  }
}
