// ignore_for_file: library_private_types_in_public_api, unused_import, unused_local_variable, avoid_print, file_names

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/Address/AddressPage.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/Order.dart' as my_order;
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/CurrentOrdersScreen.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/providers/order_data.dart';
import 'package:gangaaramtech/pages/cart/CartProvider.dart';
import 'package:gangaaramtech/repository/firestorefunctions.dart';
import 'package:provider/provider.dart';

class PlacingOrder extends StatefulWidget {
  final Map<String, dynamic>? addressData;
  const PlacingOrder({Key? key, this.addressData}) : super(key: key);

  @override
  _PlacingOrderState createState() => _PlacingOrderState();
}

class _PlacingOrderState extends State<PlacingOrder> {
  FirebaseAuth auth = FirebaseAuth.instance;
  Map<String, dynamic> userData = {};
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String selectedVendorName = ''; // Store the selected vendor's name
  String selectedVendorAddress = ''; // Store the selected vendor's address
  @override
  void initState() {
    super.initState();
    fetchUserData();
    // You can perform any initialization here.
  }

  @override
  void dispose() {
    // Dispose of any resources, such as streams or controllers.
    super.dispose();
  }

  Future<void> fetchUserData() async {
    Map<String, dynamic> data = await FireStoreFunctions().getUserData();
    setState(() {
      userData = data;
    });
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

  @override
  Widget build(BuildContext context) {
    final orderDataProvider = Provider.of<OrderDataProvider>(context);
    // Retrieve the CartProvider
    final cartProvider = Provider.of<CartProvider>(context);
    final selectedVendorUid = cartProvider.selectedVendorUid;

    // Retrieve medicine details from the CartProvider
    final cartItems = cartProvider.cartItems;
    // Calculate delivery charges and taxes
    const deliveryCharge = 10.0;
    const taxes = 5.0;

    // Calculate the total cost including delivery charges and taxes
    final totalCost = cartProvider.totalCost + deliveryCharge + taxes;
    final pharmacyName = cartProvider.pharmacyName;
    return WillPopScope(
      onWillPop: () async {
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        cartProvider.clearCart(); // Clear the cart data
        return true; // Allow navigation back
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            //Text(selectedVendorUid!),
            Align(
                alignment: Alignment.centerLeft,
                child: Text("Pharmacy Name $pharmacyName ")),
            //  Text(pharmacyName),
            const Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Order Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            ListView.builder(
              itemCount: cartItems.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = cartItems[index];

                return Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        ' ${item.medicineName}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Text(
                      ' ${item.quantity}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    Text(
                      '₹${(item.quantity * item.cost).toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 5,
            ),
            FDottedLine(
              color: Colors.black,
              width: 400,
              strokeWidth: 1.0,
              dottedLength: 2.0,
              space: 2.0,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                const Text("Delivery Charges"),
                const Spacer(),
                Text(
                  '₹${deliveryCharge.toStringAsFixed(2)}',
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                const Text(" Taxes"),
                const Spacer(),
                Text(
                  ' ₹${taxes.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                const Text("Total cost "),
                const Spacer(),
                Text(
                  '₹${totalCost.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Row(
              children: [
                SizedBox(
                  width: 20,
                ),
               
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select a Payment Method :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
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
                        ),
                        Image.asset(
                          imagePath,
                          width: 30, // Set an appropriate width for your image
                          height:
                              30, // Set an appropriate height for your image
                        ),
                        const SizedBox(width: 10),
                        Text(method),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  " Delivery address",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddressScreen()));
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
                        '${widget.addressData!['fullName']}, ${widget.addressData!['mobileNumber']},${widget.addressData!['doorNo']}, ${widget.addressData!['street']}, ${widget.addressData!['landmark']}, ${widget.addressData!['city']}, ${widget.addressData!['state']}, ${widget.addressData!['postalCode']}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () {
                    // Get the selected vendor UID from your provider or any other source
                    String? selectedVendorUid = cartProvider.selectedVendorUid;

                    List<String> medicineNames = [];
                    List<int> medicineQuantities = [];
                    List<double> medicineCosts = [];

                    for (var item in cartItems) {
                      medicineNames.add(item.medicineName);
                      medicineCosts.add(item.quantity * item.cost);
                      medicineQuantities.add(item.quantity);
                    }

                    placeOrder(
                        my_order.MyOrder(
                            address: widget.addressData as Map<String, dynamic>,
                            orderId: generateOrderID(),
                              isPrescription: false,
                            orderedTime: DateTime.now(),
                            quantity: medicineQuantities,
                            pharmacyName: pharmacyName,
                            paymentMethod: selectedPaymentMethod,
                            deliveryCharges: deliveryCharge,
                            taxes: taxes,
                            total: totalCost,
                            userUid: userData['uid'],
                            medicinesNames: medicineNames,
                            cost: medicineCosts,
                            status: 'pending'),
                        selectedVendorUid!,
                        widget.addressData);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CurrentOrdersScreen()),
                    );
                    // Place the order logic here
                  },
                  child: const Text('Place Order'),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

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

  Future<void> placeOrder(
    my_order.MyOrder order,
    String selectedVendorUid,
    Map<String, dynamic>? addressData,
  ) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userUID = user.uid;

        if (addressData != null) {
          // Add the address data to the order document
          order.address = addressData;
        }

        // Add the order to the user's orders collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userUID)
            .collection('orders')
            .doc(order.orderId) // Use the order ID as the document ID
            .set(order.toMap());

        // Add the order to the vendor's orders collection
        await FirebaseFirestore.instance
            .collection('vendors')
            .doc(selectedVendorUid)
            .collection('orders')
            .doc(order.orderId) // Use the order ID as the document ID
            .set(order.toMap());
            
        // If successful, you may want to update the UI or show a success message.
      } else {
        // Handle the case where the user is not authenticated.
      }
    } catch (error) {
      // Handle any errors that may occur during order placement.
      print("Error placing order: $error");
    }
  }
}
