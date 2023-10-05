// ignore_for_file: avoid_print, library_private_types_in_public_api, file_names

import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/Address/EditAddressPage.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/providers/order_data.dart';
import 'package:provider/provider.dart';



class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  String selectedAddressId = '';
  String selectedPaymentMethod = ''; // Store the selected payment method
  double deliveryCharges = 10.0; // Example delivery charges
  double taxes = 5.0; // Example taxes
  bool isAddNewAddressButtonVisible = true; // Set to true by default

  @override
  void initState() {
    super.initState();
    // You can perform any initialization here.
  }

  @override
  void dispose() {
    // Dispose of any resources, such as streams or controllers.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderDataProvider = Provider.of<OrderDataProvider>(context);
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

    // Access order data
    final pharmacyName = orderDataProvider.pharmacyName;
    final medicines = orderDataProvider.medicines;

    // Calculate the total cost of medicines
    double totalMedicineCost = 0.0;
    for (final medicine in medicines) {
      totalMedicineCost += medicine.quantity * medicine.price;
    }

    // Calculate the total cost including delivery charges and taxes
    double totalCost = totalMedicineCost + deliveryCharges + taxes;

    // Check if a payment method is selected
    bool isPaymentMethodSelected = selectedPaymentMethod.isNotEmpty;

    return Scaffold(
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
      body: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              " Order details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text('Pharmacy Name: $pharmacyName'),
          const SizedBox(height: 10),
          const Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Text(
                " Medicine Names",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Text(
                " Qty x Price",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 15,
              )
            ],
          ),
          for (final medicine in medicines)
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Text('${medicine.name}:'),
                const Spacer(),
                Text(' ${medicine.quantity} x ${medicine.price}'),
                const SizedBox(
                  width: 15,
                )
              ],
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
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              const Text("Delivery charges; "),
              const Spacer(),
              Text('\$${deliveryCharges.toStringAsFixed(2)}'),
              const SizedBox(
                width: 15,
              )
            ],
          ),
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              const Text("Taxes; "),
              const Spacer(),
              Text(' \$${taxes.toStringAsFixed(2)}'),
              const SizedBox(
                width: 15,
              )
            ],
          ),
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              const Text("Total Cost "),
              const Spacer(),
              Text(' \$${totalCost.toStringAsFixed(2)}'),
              const SizedBox(
                width: 15,
              )
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Select a Payment Method :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            children: paymentMethods.map((paymentMethod) {
              final imagePath = paymentMethod['imagePath']!;
              final method = paymentMethod['method']!;

              return ListTile(
                leading: Radio<String>(
                  value: method,
                  groupValue: selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value!;
                    });
                  },
                ),
                title: Row(
                  children: [
                    Image.asset(
                      imagePath,
                      width: 30, // Set an appropriate width for your image
                      height: 30, // Set an appropriate height for your image
                    ),
                    const SizedBox(width: 10),
                    Text(method),
                  ],
                ),
                onTap: () {
                  // Handle payment method selection here
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: fetchAddresses(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Check if there are addresses in the snapshot
                final hasAddresses =
                    snapshot.hasData && snapshot.data!.docs.isNotEmpty;

                // Display the "Add New Address" button only when no addresses are present
                isAddNewAddressButtonVisible = !hasAddresses;

                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: snapshot.data!.docs.map((document) {
                          Map<String, dynamic> addressData =
                              document.data() as Map<String, dynamic>;
                          String addressId = document.id;
                          bool isSelected = selectedAddressId == addressId;

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: Radio<String>(
                                    value: addressId,
                                    groupValue: selectedAddressId,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedAddressId = value!;
                                      });
                                    },
                                  ),
                                  title: Text(
                                    ' ${addressData['fullName']}, ${addressData['mobileNumber']}, ${addressData['doorNo']}, ${addressData['street']}, ${addressData['city']}, ${addressData['postalCode']}, ${addressData['state']}',
                                  ),
                                ),
                                if (isSelected)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 20),
                                      Container(
                                        width: double.infinity,
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Map<String, dynamic> addressData =
                                                document.data()
                                                    as Map<String, dynamic>;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddressPage(
                                                  isEditing: true,
                                                  addressData: addressData,
                                                  selectedAddressId: addressId,
                                                ),
                                              ),
                                            );
                                          },
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                OutlinedBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                          ),
                                          child: const Text(
                                            "Edit address",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Handle removing the address here
                                            removeAddress(addressId);
                                          },
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                OutlinedBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                          ),
                                          child: const Text(
                                            "Remove this address",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      if (!isPaymentMethodSelected)
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Use this address for delivery
                                              // You can add your logic here
                                            },
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                  OutlinedBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                            ),
                                            child: const Text(
                                              "Use This Address for Delivery",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (isAddNewAddressButtonVisible)
                      Column(
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddressPage(isEditing: false),
                                ),
                              );
                            },
                            child: const Text('Add New Address'),
                          ),
                          const SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                  ],
                );
              },
            ),
          ),
          if (isPaymentMethodSelected && selectedAddressId.isNotEmpty)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle placing the order here
                        // You can add your logic to place the order
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      child: const Text('Place Order'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

Future<void> removeAddress(String addressId) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userUID = user.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userUID)
          .collection('addresses')
          .doc(addressId) // Specify the document ID to delete
          .delete();

      // If successful, you may want to update the UI or show a success message.
    } else {
      // Handle the case where the user is not authenticated.
    }
  } catch (error) {
    // Handle any errors that may occur during the deletion.
    print("Error removing address: $error");
  }
}

Stream<QuerySnapshot> fetchAddresses() {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    String userUID = user.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .collection('addresses')
        .snapshots();
  } else {
    // Return an empty stream if no user is authenticated
    return const Stream.empty();
  }
}
