// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/Address/EditAddressPage.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/Prescription/OrderPlacing/Prescription_Orde_Placing2/OrderplacingScreen.dart';

class PrescriptionAddressScreen extends StatelessWidget {
  final String orderID;
  final String vendorUid;
  const PrescriptionAddressScreen(
      {super.key, required this.orderID, required this.vendorUid});

  @override
  Widget build(BuildContext context) {
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
          Expanded(
              child: AddressList(
            orderID: orderID,
            vendorUid: vendorUid,
          )),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddressPage(
                      isEditing: false,
                    ),
                  ),
                );
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.blue), // Change the color to your preference
              ),
              child: const Text(
                "Add New Address",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddressList extends StatefulWidget {
  final String orderID;
  final String vendorUid;
  const AddressList(
      {super.key, required this.orderID, required this.vendorUid});

  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  String selectedAddressId = ''; // Store the ID of the selected address

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No addresses found.'),
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((document) {
            Map<String, dynamic> addressData =
                document.data() as Map<String, dynamic>;
            String addressId = document.id;
            // Get the address ID

            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                  if (selectedAddressId == addressId)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              // print(addressId);
                              Map<String, dynamic> addressData =
                                  document.data() as Map<String, dynamic>;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddressPage(
                                    isEditing: true,
                                    addressData: addressData,
                                    selectedAddressId: addressId,
                                  ),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                            ),
                            child: const Text(
                              "Edit address",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              Map<String, dynamic> addressData =
                                  document.data() as Map<String, dynamic>;
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => OrderPlacingScreen(
                                          vendorUid: widget.vendorUid,
                                          orderID: widget.orderID,
                                        )),
                              );
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.vendorUid)
                                  .collection('orders')
                                  .doc(widget.orderID)
                                  .update({'address': addressData});
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                            ),
                            child: const Text(
                              "Use this address for delivery",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              removeAddress(addressId);
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                            ),
                            child: const Text(
                              "Remove this address",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                ],
              ),
            );
          }).toList(),
        );
      },
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
    // You can show an error message to the user if needed.
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
