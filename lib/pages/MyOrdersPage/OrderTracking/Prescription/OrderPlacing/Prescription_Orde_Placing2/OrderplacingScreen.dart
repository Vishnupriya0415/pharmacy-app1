// ignore_for_file: avoid_print, non_constant_identifier_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/Vendor/Orders/SuccessPage.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/Prescription/OrderPlacing/Prescription_Orde_Placing2/AddressScreen.dart';

class OrderPlacingScreen extends StatefulWidget {
  final String vendorUid;
  final String orderID;
  final double? cost;
  final String? imageUrl;
  final Map<String, dynamic>? addressData; // New parameter for address data

  
  const OrderPlacingScreen(
      {super.key,
      required this.vendorUid,
      required this.orderID,
      this.cost,
      this.imageUrl,
      this.addressData});

  @override
  State<OrderPlacingScreen> createState() => _OrderPlacingScreenState();
}

//Display image and cost and provide an option for selecting an address and payment methods then order will be places
class _OrderPlacingScreenState extends State<OrderPlacingScreen> {
  User? user;
  String userUID = '';

  String imageURL = '';
  double total = 0.0;
  String doorNo = '';
  String city = '';
  String phoneNum = '';
  String state = '';
  String street = '';
  String pinCode = '';
  String pharmacyName = '';
  String Name = '';
  String mobileNumber = '';
  String landmark = '';
  @override
  void initState() {
    super.initState();
    // Fetch the image URL from Firestore
    fetchImageURL();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userUID = user!.uid;
    }
  }

  final List<Map<String, String>> paymentMethods = [
    {
      'imagePath': 'assets/images/tablets/creditcard_icon.png',
      'method': 'Debit/credit card',
    },
    {
      'imagePath': 'assets/images/tablets/phonepe_icon.webp',
      'method': 'Phone Pe',
    },
    {
      'imagePath': 'assets/images/tablets/paytm_icon.png',
      'method': 'Paytm',
    },
    {
      'imagePath': 'assets/images/tablets/googlePay.png',
      'method': 'Google Pay',
    },
    {
      'imagePath': 'assets/images/tablets/cash_on_delivery.jpg',
      'method': 'Cash on Delivery',
    },
  ];

  String selectedPaymentMethod = ''; // Store the selected payment method

  Future<void> fetchImageURL() async {
    try {
      // You can replace 'users' and 'orders' with your actual collection and sub-collection names
      DocumentSnapshot orderDocument = await FirebaseFirestore.instance
          .collection('users') // Change to your collection name
          .doc(widget.vendorUid) // Use the appropriate document path
          .collection('orders') // Change to your sub-collection name
          .doc(widget.orderID)
          .get();

      if (orderDocument.exists) {
        // Assuming 'imageUrl' is the field that contains the image URL in your order document
        setState(() {
          imageURL = orderDocument.get('imageURL');
          total = orderDocument.get('total');
          doorNo = orderDocument.get('address.doorNo');
          city = orderDocument.get('address.city');
          street = orderDocument.get('address.street');
          pinCode = orderDocument.get('address.postalCode');
          Name = orderDocument.get('address.fullName');
          mobileNumber = orderDocument.get('address.mobileNumber');
          landmark = orderDocument.get('address.landmark');
        });
      }
    } catch (error) {
      print("Error fetching image URL: $error");
      // Handle any errors that may occur during fetching.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Order placing ",
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
        child: Column(
          children: [
            //     const Text(" Order Placing Screen"),
            const SizedBox(
              height: 20,
            ),
            if (imageURL.isNotEmpty) Image.network(imageURL),
            const SizedBox(height: 16),
            if (total != 0.0)
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  
                  const Text(
                    'Total cost ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text('₹$total'),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            const SizedBox(height: 16),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  " Delivery address",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            //  const SizedBox(height: 16),
            Card(
                child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => PrescriptionAddressScreen(
                                orderID: widget.orderID,
                                vendorUid: widget.vendorUid,
                              )),
                    );
                  },
                  child: const Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "Change",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                Text(
                    '$Name, $mobileNumber,$doorNo, $landmark, $street, $city, $state,$pinCode'),
              ],
            )),
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Select a Payment Method :',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: paymentMethods.map((paymentMethod) {
                  final imagePath = paymentMethod['imagePath']!;
                  final method = paymentMethod['method']!;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPaymentMethod = method;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: selectedPaymentMethod == method
                            ? Colors
                                .blue // Highlight the selected payment method
                            : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: method,
                            groupValue: selectedPaymentMethod,
                            onChanged: (value) {
                              setState(() {
                                selectedPaymentMethod = value!;
                              });
                            },
                            activeColor: Colors.blue,
                          ),
                          Image.asset(
                            imagePath,
                            width:
                                30, // Set an appropriate width for your image
                            height:
                                30, // Set an appropriate height for your image
                          ),
                          const SizedBox(width: 10),
                          Text(
                            method,
                            style: TextStyle(
                              fontSize: 16,
                              color: selectedPaymentMethod == method
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () async {
                    // Perform the update operation
                    try {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userUID)
                          .collection('orders')
                          .doc(widget.orderID)
                          .update({
                        'paymentMethod': selectedPaymentMethod,
                        'status': 'Accepted'
                      });
                      await FirebaseFirestore.instance
                          .collection('vendors')
                          .doc(widget.vendorUid)
                          .collection('orders')
                          .doc(widget.orderID)
                          .update({
                        'paymentMethod': selectedPaymentMethod,
                        'status': 'Accepted'
                      });

                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const SuccessPage()),
                      );
                      // Show a Snackbar on success
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Order placed successfully.'),
                        ),
                      );
                    } catch (error) {
                      // Handle any errors that may occur during the update.
                      print("Error updating order: $error");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue, // Button text color
                    padding: const EdgeInsets.all(5),
                  ),
                  child: const Text("Place order"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
