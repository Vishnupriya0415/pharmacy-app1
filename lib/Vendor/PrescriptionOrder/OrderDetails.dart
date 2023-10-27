// ignore_for_file: no_logic_in_create_state, avoid_print, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderID;
  final String imageUrl;

  const OrderDetailsPage({super.key, 
    required this.orderID,
    required this.imageUrl,
  });

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState(orderID);
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final String orderID;
  double? totalPrice;

  _OrderDetailsPageState(this.orderID);

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
      try {
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
        }
      } catch (e) {
        // Handle the error, for example, show an error message
        print("Error fetching total price: $e");
      }
    }
  }

  Future<void> updateTotalPrice(double newTotal) async {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String? userUID = user?.uid;

    if (userUID != null) {
      try {
        // Update the total price in the vendor's collection
        DocumentReference vendorOrderReference = firestore
            .collection('vendors')
            .doc(userUID)
            .collection('orders')
            .doc(orderID);

        await vendorOrderReference.update({'total': newTotal});

        vendorOrderReference.get().then((documentSnapshot) async {
          if (documentSnapshot.exists) {
            Map<String, dynamic> data = documentSnapshot.data()
                as Map<String, dynamic>; // Explicit casting
            String userUid = data['userUid'];
            print('userUid: $userUid');
             DocumentReference userOrderReference = firestore
            .collection('users')
            .doc(userUid)
            .collection('orders')
            .doc(orderID);

        await userOrderReference.update({'total': newTotal});

          } else {
            print('Document with orderID not found');
          }
        }).catchError((error) {
          print('Error getting document: $error');
        });

        // Update the total price in the user's collection
       

        setState(() {
          totalPrice = newTotal;
        });
      } catch (e) {
        // Handle the error, e.g., show an error message
        print("Error updating total price: $e");
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
              TextButton(
                onPressed: () {
                  // Show an alert dialog with an input field for the total price
                  TextEditingController priceController =
                      TextEditingController();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Enter Total Price"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Please enter the total price:"),
                            TextField(
                              controller: priceController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () async {
                              double enteredPrice =
                                  double.tryParse(priceController.text) ?? 0.0;
                              updateTotalPrice(enteredPrice);
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text("Add Cost"),
              ),
          ],
        ),
      ),
    );
  }
}
