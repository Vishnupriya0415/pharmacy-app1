// ignore_for_file: use_build_context_synchronously, avoid_print, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/Prescription/OrderPlacing/Prescription_Orde_Placing2/AddressScreen.dart';
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

/*
bool isOrderCreated = false; // Add a flag to track order creation

  Future<void> createOrder() async {
    if (isOrderCreated) {
      // Order has already been created, do nothing
      return;
    }

    isOrderCreated =
        true; // Set the flag to indicate that the order is being created

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
        double total = subcollectionData['total'] ?? '';
        if (total != 0.0) {
          orderData['total'] = total;
          print(total);
          // Store the order in the user's "orders" subcollection
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userUID)
              .collection('orders')
              .doc(orderID)
              .set(orderData);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Order has been created successfully.'),
            ),
          );
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SuccessPage()),
          );
          print("Total cost is added by the vendor");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Please wait while the vendor is processing your request.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(' Wait while the vendor is processing your request.'),
          ),
        );
       
      }
    } catch (e) {
      isOrderCreated = false;
    }
  }
*/
  int buttonPressCount = 0; // Initialize a counter to track button presses
  bool isOrderCreated = false;
  String orderID = ''; // Define orderID outside the if block
  Map<String, dynamic> orderData = {}; // Define orderData outside the if block

  Future<void> createOrder() async {
    buttonPressCount++; // Increase the counter with each button press

    User? user = FirebaseAuth.instance.currentUser;
    String? userUID = user?.uid;

    if (buttonPressCount == 1) {
      orderID = generateOrderID();
      print("The orderid is $orderID");

      orderData = {
        'orderId': orderID,
        'imageURL': widget.imageUrl,
        'vendorName': vendorName,
        'status': 'pending',
        "isPrescription": true,
      };

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

      await FirebaseFirestore.instance
          .collection('vendors')
          .doc(widget.vendorUid)
          .collection('orders')
          .doc(orderID)
          .set(orderData);

      await FirebaseFirestore.instance
          .collection('vendors')
          .doc(widget.vendorUid)
          .collection('orders')
          .doc(orderID)
          .update({'userUid': userUID});

      isOrderCreated = true;

      // Show a message to the user indicating that the order has been created
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Order has been created successfully and the request is sent to vendor for further processing .'),
        ),
      );
    } else {
      // This is not the first button press, so check if the "total" value exists in the order document

      DocumentSnapshot subcollectionDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUID)
          .collection('orders')
          .doc(orderID)
          .get();

      if (subcollectionDoc.exists) {
        Map<String, dynamic> subcollectionData =
            subcollectionDoc.data() as Map<String, dynamic>;
        double total = subcollectionData['total'] ?? 0.0;
        print("Total Value: $total");
        if (total != 0.0) {
          // The "total" value exists, proceed with navigation...
          setState(() {
            orderData['total'] = total;
          });
          print(total);
          // Navigate to the next screen
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => PrescriptionAddressScreen(
                      orderID: subcollectionData['orderId'],
                      vendorUid: subcollectionData['vendorUid'],
                    )),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Vendor has processed your request and the cost is $total.'),
            ),
          );
          print("Total cost is added by the vendor");
        } else {
          // The "total" value does not exist, show a message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Please wait while the vendor is processing your request.'),
            ),
          );
        }
      } else {
        // The order document doesn't exist, show a message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Order document doesn\'t exist.Try placing an order again'),
          ),
        );
      }
    }
  }

  String generateOrderID() {
    DateTime now = DateTime.now();
    int random = Random().nextInt(9000) + 1000;
    String orderID =
        'OD${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}$random';
    return orderID;
  }

  @override
  void dispose() {
    _isDisposed = true;
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
