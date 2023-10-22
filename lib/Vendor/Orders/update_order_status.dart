// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:gangaaramtech/utils/constants/color_constants.dart';
import 'package:gangaaramtech/utils/constants/font_constants.dart';
import 'package:gangaaramtech/utils/widgets/custom_elevated_button.dart';

class VendorOrderStatusScreen extends StatefulWidget {
  final String orderId;

  const VendorOrderStatusScreen({required this.orderId, Key? key}) : super(key: key);

  @override
  _VendorOrderStatusScreenState createState() =>
      _VendorOrderStatusScreenState();
}

class _VendorOrderStatusScreenState extends State<VendorOrderStatusScreen> {
  String _selectedStatus = 'Pending'; // Default status

  // Define a list of order status options
  final List<String> _orderStatusOptions = [
    'Pending',
    'Processing',
    'Out for Delivery',
    'Delivered',
  ];

  @override
  void initState() {
    super.initState();
    // Fetch the current status from the database and set it as the default
    fetchCurrentStatus();
  }

  Future<void> fetchCurrentStatus() async {
    try {
      final orderId = widget.orderId; // Get the orderId from the widget

      // Reference to the order document in Firestore
      final orderRef =
          FirebaseFirestore.instance.collection('orders').doc(orderId);

      // Fetch the current status from Firestore
      final orderSnapshot = await orderRef.get();
      if (orderSnapshot.exists) {
        final data = orderSnapshot.data() as Map<String, dynamic>;
        final currentStatus = data['status'] as String;

        // Print the fetched status for debugging
        print('Fetched status: $currentStatus');

        // Set the current status as the default
        setState(() {
          _selectedStatus = currentStatus;
        });
      }
    } catch (error) {
      print('Error fetching current order status: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Order Status',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Dropdown to select the order status
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                hintText: 'Select Order Status',
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
                border: const UnderlineInputBorder(
                  borderSide: BorderSide.none,
                  // Remove the border line
                ),
              ),
              value: _selectedStatus,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStatus = newValue!;
                });
              },
              items: _orderStatusOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
            ),
            const SizedBox(height: 10.0),
            // Button to update the order status
            CustomElevatedButton(
              onTap: () {
                updateOrderStatus(_selectedStatus, widget.orderId);
                // Pass orderId to updateOrderStatus
                Navigator.pop(context);
              },
              text: "Update Order Status",
              margin: const EdgeInsets.only(
                top: 31,
              ),
              buttonStyle: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                elevation: 12,
              ).copyWith(
                fixedSize: MaterialStateProperty.all<Size>(
                  const Size(
                    double.maxFinite,
                    50,
                  ),
                ),
              ),
              buttonTextStyle: FontConstants.button.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to update the order status in Firestore
  Future<void> updateOrderStatus(String newStatus, String orderId) async {
    try {
      final vendorId =
          FirebaseAuth.instance.currentUser?.uid; // Get the vendor's UID

      // Reference to the order document in Firestore under the vendor's subcollection
      final orderRef = FirebaseFirestore.instance
          .collection('vendors')
          .doc(vendorId)
          .collection('orders')
          .doc(orderId);

      // Update the status field in Firestore
      await orderRef.update({
        'status': newStatus,
      });

      print('Updating order status for Order ID $orderId to: $newStatus');
    } catch (error) {
      print('Error updating order status: $error');
    }
  }
}
