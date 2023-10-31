import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderTrackingPage extends StatelessWidget {
  final String orderId;

  OrderTrackingPage({required this.orderId});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Tracking'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid) // Assuming you have a unique user ID for the current user
            .collection('orders')
            .doc(orderId) // Assuming 'orderId' is a field in the 'orders' collection
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator(); // Loading indicator
          }

          final orderData = snapshot.data!.data() as Map<String, dynamic>;

          final status = orderData['status'];

          final orderedTime = orderData['orderedTime'] as Timestamp;
          final acceptedTime = orderData['acceptedTime'];
          final orderStatusTime =
              orderData['orderStatusTime'] as Map<String, dynamic>;

          String orderedTimeString = ''; // Initialize an empty string
          String processingTimeString = ''; // Initialize an empty string
          String acceptedTimeString = ''; // Initialize an empty string
          String outForDeliveryTimeString = ''; // Initialize an empty string

          if (orderedTime != null) {
            final orderedDateTime = orderedTime.toDate();
            orderedTimeString =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(orderedDateTime);
          }

          if (status == 'Processing' || status == 'Out for Delivery') {
            final processingTime =
                orderStatusTime['processingTime'] as Timestamp;
            if (processingTime != null) {
              final processingDateTime = processingTime.toDate();
              processingTimeString =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(processingDateTime);
            }
          }

          if (acceptedTime != null) {
            final acceptedDateTime = acceptedTime.toDate();
            acceptedTimeString =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(acceptedDateTime);
          }

          if (status == 'Out for Delivery') {
            final outForDeliveryTime =
                orderStatusTime['outForDeliveryTime'] as Timestamp;
            if (outForDeliveryTime != null) {
              final outForDeliveryDateTime = outForDeliveryTime.toDate();
              outForDeliveryTimeString =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(outForDeliveryDateTime);
            }
          }

          return Card(
            child: ListTile(
              title: Text('Order ID: $orderId'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Status: $status'),
                  if (status == 'Accepted' ||
                      status == 'Processing' ||
                      status == 'Out for Delivery')
                    Column(
                      children: [
                        Text('Ordered Time: $orderedTimeString'),
                        Text('Accepted time: $acceptedTimeString'),
                        Text('Processing Time: $processingTimeString'),
                        if (status == 'Out for Delivery')
                          Text('Out For Delivery Time: $outForDeliveryTimeString'),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
