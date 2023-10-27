// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PrescriptionOrderDetailsScreen extends StatelessWidget {
  final String orderId;

  PrescriptionOrderDetailsScreen({Key? key, required this.orderId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Order Details'),
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection(
                  'users') // Replace with your Firestore collection name
              .doc(user.uid) // Assuming the user ID is used to identify orders
              .collection('orders')
              .doc(orderId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('Order not found'));
            }

            final orderData = snapshot.data!.data() as Map<String, dynamic>;
            final imageURL =
                orderData['imageURL']; // Replace with your image URL field name
            final status = orderData['status'];
            final totalCost =
                orderData['total']; // Replace with your total cost field name
            final city = orderData['address']['city'];
            final doorNo = orderData['address']['doorNo'];
            final pinCode = orderData['address']['postalCode'];
            final state = orderData['address']['state'];
            final street = orderData['address']['street'];
            final landmark = orderData['address']['landmark'];
            final Name = orderData['address']['fullName'];
            final phone = orderData['address']['mobileNumber'];
            final fullAddress =
                '$doorNo, $street, $landmark, $city, $state - $pinCode\n$Name';
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text("Ordered by  $Name"),
                        const Spacer(),
                        Text('Phone : $phone')
                      ],
                    ),
                    Text("Status :$status"),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(child: Image.network(imageURL)),
                    // Display the image
                    Row(
                      children: [
                        const Text(" Total Cost:"),
                        const Spacer(),
                        Text(" ₹$totalCost"),
                      ],
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Delivery Address',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(fullAddress),
                  ],
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text(' Some Error exists plase try again'),
        ),
        body: const Center(
          child: Text('Error: User not authenticated'),
        ),
      );
    }
  }
}
