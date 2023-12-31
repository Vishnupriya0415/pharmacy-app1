// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final vendorId = user.uid;

      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('vendors')
            .doc(vendorId)
            .collection('orders')
            .doc(orderId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.hasData) {
            final orderData = snapshot.data!.data() as Map<String, dynamic>?;

            if (orderData != null) {
              final addressData = orderData['address'];
              final medicineNames = orderData['medicineNames'];
              final quantity = orderData['quantity'];
              final cost = orderData['cost'];
              final taxes = orderData['taxes'];
              final addressText =
                  '${addressData['doorNo']}, ${addressData['landmark']},${addressData['street']},${addressData['state']} ${addressData['postalCode']}';
              final deliveryCharge = orderData['deliveryCharges'];
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
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     
                      Text(
                          'Customer Name: ${orderData['address']['fullName']}'),
                      Text(
                          'Phone Number: ${orderData['address']['mobileNumber']}'),
                      const SizedBox(
                        height: 10,
                      ),
                     const  Row(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Icon(Icons.home, color: Colors.black),
                          // Add a home icon here
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            " Delivery Address",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(' $addressText'),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        children: [
                          SizedBox(
                              width: 95,
                              child: Text(
                                'Medicine Names:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          Text(
                            'Quantity',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            'Cost',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: medicineNames.map<Widget>((medicineName) {
                              return SizedBox(
                                  width: 105,
                                  child: Text(medicineName.toString()));
                            }).toList(),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: quantity.map<Widget>((quantity) {
                              return Text(quantity.toString());
                            }).toList(),
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: cost.map<Widget>((cost) {
                              return Text(' ₹${cost.toStringAsFixed(2)}');
                            }).toList(),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Text('DeliveryCharges'),
                          const Spacer(),
                          Text('₹$deliveryCharge'),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Taxes'),
                          const Spacer(),
                          Text('₹$taxes'),
                        ],
                      ),
                      const SizedBox(height: 2),
                      FDottedLine(
                        color: Colors.black,
                        width: 400,
                        strokeWidth: 1.0,
                        dottedLength: 2.0,
                        space: 2.0,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Text(
                            'Total Cost:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Text('₹${orderData['total']}'),
                        ],
                      ),
                     
                    ],
                  ),
                ),
              );
            } else {
              return const Text(
                  'Order data is null or not in the expected format.');
            }
          } else {
            return const Text('Order not found.');
          }
        },
      );
    } else {
      return const Text('User is not authenticated');
    }
  }
}
