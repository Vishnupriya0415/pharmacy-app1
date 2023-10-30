// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import the Firestore package

class DetailsScreen extends StatelessWidget {
  final String orderId;
  const DetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    final vendorId = user?.uid;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ), // Use appropriate icon for back arrow
          onPressed: () {
            Navigator.pop(
                context); // Go back to the previous screen on arrow button press
          },
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('vendors')
            .doc(vendorId)
            .collection('orders')
            .doc(orderId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Data is still loading
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Error occurred
            return Text("Error: ${snapshot.error}");
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            // Document does not exist
            return const Text("Order not found");
          } else {
            // Data is ready, display it
            final data = snapshot.data!.data() as Map<String, dynamic>;
            final imageURL = data['imageURL'];
            final total = data['total'];
            final city = data['address']['city'];
            final doorNo = data['address']['doorNo'];
            final postalCode = data['address']['postalCode'];
            final state = data['address']['state'];
            final name = data['address']['fullName'];
            final mobileNumber = data['address']['mobileNumber'];
            final landmark = data['address']['landmark'];
            final street = data['address']['street'];
            final addressText =
                '$name,$mobileNumber,$doorNo,$street,$landmark,$city, $state,$postalCode';
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('order ID " $orderId'),
                        const Spacer(),
                        Text('Total: ₹${total.toStringAsFixed(2)}'),
                        const SizedBox(
                          width: 5,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Image.network(
                      imageURL, // Display the image using the imageURL
                      width: double.maxFinite, // Set the width as needed
                      height: 300, // Set the height as needed
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          " Delvery address:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(addressText),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
