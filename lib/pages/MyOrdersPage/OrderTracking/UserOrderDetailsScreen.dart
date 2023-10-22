// ignore_for_file: library_private_types_in_public_api, avoid_print, file_names

import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserOrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const UserOrderDetailsScreen({Key? key, required this.orderId})
      : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<UserOrderDetailsScreen> {
  User? user;
  String orderStatus = 'Loading...';
  List<String> medicineNames = [];
  List<int> quantity = [];
  List<double> cost = [];
  double total = 0.0;
  double deliveryCharge = 0.0;
  double taxes = 0.0;
  Map<String, dynamic>? addressData;
  String pharmacyName = '';

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('orders')
          .doc(widget.orderId)
          .get();

      if (snapshot.exists) {
        final orderData = snapshot.data() as Map<String, dynamic>;
        orderStatus = orderData['status'];
        medicineNames = List<String>.from(orderData['medicineNames']);
        cost = List<double>.from(orderData['cost']);
        quantity = List<int>.from(orderData['quantity']);
        total = orderData['total'] ?? 0.0;
        
        pharmacyName = orderData['pharmacyName'];
        quantity = List<int>.from(orderData['quantity']);

        if (orderData['deliveryCharge'] != null) {
          deliveryCharge = orderData['deliveryCharge'];
        }
        if (orderData['quantity']! - null) {
          quantity = orderData['quantity'];
        }

        if (orderData['taxes'] != null) {
          taxes = orderData['taxes'];
        }

        if (orderData['address'] != null) {
          addressData = orderData['address'];
        }

        //  addressData = orderData['address'];
        print(
            'Address Data: $addressData'); // Add this line to print the address data

        setState(() {
          orderStatus = orderData['status'];
        });

        // Fetch the address data
        print('Address Data: $addressData');
       
      } else {
        setState(() {
          orderStatus = 'Order not found';
        });
      }
    } catch (error) {
      setState(() {
        orderStatus = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Order Details - ${widget.orderId}',
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Card(
        elevation: 5,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 
                if (addressData != null)
                  Text(
                    "Ordered by ${addressData!['fullName']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 5),
                if (addressData != null)
                  Text(
                    "Phone ${addressData!['mobileNumber']}",
                  ),
                const SizedBox(height: 5),
                
                if (addressData != null)
                  Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          " Delivery Address:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      
                      Text(
                        " ${addressData! ['doorNo']}, ${addressData!['street']}, ${addressData!['landmark']}, ${addressData!['city']}, ${addressData!['state']}, ${addressData!['postalCode']}",
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 10,
                ),
                Text(' Ordered  from $pharmacyName'),
                Row(
                  children: [
                    Text(
                      'Order ID: ${widget.orderId}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    //  Text('Status: $orderStatus'),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Order details',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Row(
                  children: [
                    SizedBox(width: 200, child: Text('Medicine Names')),
                    Text(" Qty"),
                    Spacer(),
                    Text('Cost')
                  ],
                ),
                for (int i = 0; i < medicineNames.length; i++) ...[
                  Row(
                    children: [
                      SizedBox(width: 200, child: Text(medicineNames[i])),
                      if (quantity.isNotEmpty && i < quantity.length)
                        Text(' ${quantity[i]}'),
                      const Spacer(),
                      if (cost.isNotEmpty && i < cost.length)
                        Text(' ₹${cost[i]}'),
                    ],
                  ),
                ],
                Row(
                  children: [
                    const Text('Delivery charges'),
                    const Spacer(),
                    Text(' ₹$deliveryCharge'),
                  ],
                ),
                Row(
                  children: [
                    const Text('Taxes'),
                    const Spacer(),
                    Text(' ₹$taxes'),
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
                    const Text('Total:'),
                    const Spacer(),
                    Text('  ₹$total'),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
