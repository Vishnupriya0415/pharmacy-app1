import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/Vendor/Orders/SuccessPage.dart';
import 'package:gangaaramtech/pages/search/vendors_information1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'package:photo_view/photo_view.dart';

class PrescriptionOrder extends StatefulWidget {
  final String vendorUid;
  final String imageUrl;

  const PrescriptionOrder({
    Key? key,
    required this.vendorUid,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<PrescriptionOrder> createState() => _PrescriptionOrderState();
}

class _PrescriptionOrderState extends State<PrescriptionOrder> {
  String vendorName = "Vendor Name";
  String vendoremail = "Vendor email";
  bool _isDisposed = false;
  String city = '';
  String phoneNum = '';
  String state = '';
  String street = '';
  String doorNo = '';
  String pinCode = '';
  String pharmacyName = '';
  bool orderCreationInProgress = false;

  @override
  void initState() {
    super.initState();
    fetchVendorDetails();
  }

  Future<void> fetchVendorDetails() async {
    try {
      final DocumentSnapshot vendorDoc = await FirebaseFirestore.instance
          .collection('vendors')
          .doc(widget.vendorUid)
          .get();

      if (!_isDisposed && vendorDoc.exists) {
        final data = vendorDoc.data() as Map<String, dynamic>;
        setState(() {
          vendorName = data['Name'] ?? "Vendor Name";
          vendoremail = data['email'] ?? "Vendor Location";
          city = data['address']['city'] ?? '';
          pharmacyName = data['pharmacyName'] ?? '';
          phoneNum = data['phone'] ?? '';
          pinCode = data['address']['postalCode'] ?? '';
          doorNo = data['address']['doorNo'] ?? '';
          street = data['address']['street'] ?? '';
          state = data['address']['state'] ?? '';
        });
      }
    } catch (e) {
      if (!_isDisposed) {
        // Handle any error (e.g., log or show an error message)
      }
    }
  }

  Future<void> createOrder() async {
    if (orderCreationInProgress) {
      // Order creation is already in progress, do nothing
      return;
    }

    orderCreationInProgress = true;

    User? user = FirebaseAuth.instance.currentUser;
    String? userUID = user?.uid;

    // Generate a unique order ID using your function
    String orderID = generateOrderID();
    print("The orderid is $orderID");

    // Define the order data
    Map<String, dynamic> orderData = {
      'order': orderID,
      'imageURL': widget.imageUrl,
      'vendorName': vendorName,
      'orderState': 'pending',
      "isPrescription": true,
    };

    try {
      // Store the order in the user's "orders" subcollection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userUID)
          .collection('orders')
          .doc(orderID)
          .set(orderData);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userUID)
          .collection('orders')
          .doc(orderID)
          .update(
              {'vendorUid': widget.vendorUid, 'pharmacyName': pharmacyName});

      // Store the same order in the vendor's "orders" subcollection
      await FirebaseFirestore.instance
          .collection('vendors')
          .doc(widget.vendorUid)
          .collection('orders')
          .doc(orderID)
          .set(orderData);

      // Update the collection which includes userUid
      await FirebaseFirestore.instance
          .collection('vendors')
          .doc(widget.vendorUid)
          .collection('orders')
          .doc(orderID)
          .update({'userUid': userUID});

      DocumentSnapshot subcollectionDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUID)
          .collection('orders')
          .doc(orderID)
          .get();
      if (subcollectionDoc.exists) {
        Map<String, dynamic> subcollectionData =
            subcollectionDoc.data() as Map<String, dynamic>;
        String total = subcollectionData['total'] ?? '';

        if (total.isNotEmpty) {
          orderData['total'] = total;

          // Store the order in the user's "orders" subcollection
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userUID)
              .collection('orders')
              .doc(orderID)
              .set(orderData);
          orderCreationInProgress = false;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Order has been created successfully.'),
            ),
          );

          // Finally, navigate to the next screen
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SuccessPage()),
          );
          print("total cost is added by vendor");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Please wait while the vendor is processing your request.'),
            ),
          );
          orderCreationInProgress = false;
        }
      } else {
        // Handle the case when the subcollection document doesn't exist
        // You can show a Snackbar or take other appropriate actions
        orderCreationInProgress = false;
      }
    } catch (e) {
      // Handle any error that occurred during the order creation
      // Set the flag to false to allow trying again
      orderCreationInProgress = false;
      // Show an error message or log the error
    }
  }

  // Function to generate a unique order ID
  String generateOrderID() {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Generate a random number between 1000 and 9999
    int random = Random().nextInt(9000) + 1000;

    // Create an order ID by combining date/time and random number
    String orderID =
        'OD${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}$random';

    return orderID;
  }

  @override
  void dispose() {
    _isDisposed = true; // Set a flag to indicate that the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Prescription Order"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
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
              const SizedBox(
                height: 20,
              ),
              Text("Vendor Name: $vendorName"),
              Text("Vendor Location: $vendoremail"),
              Text('Phone Number: $phoneNum'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => VendorListScreen1(
                                imageUrl: widget.imageUrl,
                              ),
                            ),
                          );
                        },
                        child: const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Change pharmacy",
                              style: TextStyle(color: Colors.blue),
                            )),
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Pharmacy: $pharmacyName")),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("Address: $doorNo, $street, $city, $state, $pinCode")
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                        onPressed: createOrder, child: const Text("Next"))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
