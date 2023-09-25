// ignore: file_names
// ignore_for_file: must_be_immutable, unused_local_variable, prefer_final_fields, file_names, non_constant_identifier_names, duplicate_ignore, library_private_types_in_public_api, prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/Address/AddressPage.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/OrderPlacing.dart';

//import '../OrderPlacing.dart';

class AddressPage extends StatefulWidget {
  final bool isEditing;
  final Map<String, dynamic>? addressData;
  // Receive the address data
  final String? selectedAddressId; // Add this parameter

  AddressPage(
      {super.key,
      required this.isEditing,
      this.addressData,
      this.selectedAddressId});

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _doorNoController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _LandmarkController = TextEditingController();

  Future<void> _updateAddress() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          String userUID = user.uid;
          String? documentId = widget.selectedAddressId;

          // Combine the address data into a map
          String fullName = _fullNameController.text;
          String mobileNumber = _mobileNumberController.text;
          String doorNo = _doorNoController.text;
          String street = _streetController.text;
          String city = _cityController.text;
          String state = _stateController.text;
          String postalCode = _postalCodeController.text;
          String landmark = _LandmarkController.text;

          Map<String, dynamic> updatedAddressData = {
            'fullName': fullName,
            'mobileNumber': mobileNumber,
            'doorNo': doorNo,
            'street': street,
            'city': city,
            'state': state,
            'postalCode': postalCode,
            'landmark': landmark,
          };

          // print('Document ID: $documentId'); // Add this line to print the document ID

          if (documentId != null) {
            // If documentId is provided, update the existing address in the database
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userUID)
                .collection('addresses')
                .doc(documentId)
                .update(updatedAddressData);
          } else {
            // If documentId is null, add a new address to the database
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userUID)
                .collection('addresses')
                .add(updatedAddressData);
          }

          // Navigate back to the address list or perform other actions
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddressScreen(), // Pass false if not editing
            ),
          );
        } else {
          // Handle the case where no user is currently authenticated
          print('No user is currently authenticated');
        }
      } catch (e) {
        // Handle any errors that occur during the Firestore operation
        // ignore: avoid_print
        print('Error updating address: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize the controllers with the values from addressData (if it exists)
    if (widget.isEditing && widget.addressData != null) {
      final addressData = widget.addressData!;
      _fullNameController.text = addressData['fullName'] ?? '';
      _mobileNumberController.text = addressData['mobileNumber'] ?? '';
      _doorNoController.text = addressData['doorNo'] ?? '';
      _streetController.text = addressData['street'] ?? '';
      _cityController.text = addressData['city'] ?? '';
      _stateController.text = addressData['state'] ?? '';
      _postalCodeController.text = addressData['postalCode'] ?? '';
      _LandmarkController.text = addressData['landmark'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    OrderSummary summary = OrderSummary(
      items: [
        OrderItem(name: "Paracaetemol", quantity: 2, price: 10.0),
        OrderItem(name: "Cetrizeine", quantity: 3, price: 15.0),
        // Add more order items as needed
      ],
      deliveryAddress: '20-2-262/A, Koraguntla, Tirupati, Andhra Pradesh',
      deliveryCharge: 5.0, // Delivery charge
      taxes: 3.0, // Taxes
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Add New Address',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Full name (First and Last name)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:
                            Colors.white, // Set the background color to white
                        border: Border.all(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none, // Set the border to none
                        ),
                        controller: _fullNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Mobile number",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: _mobileNumberController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your mobile number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    " House no, building , apartment ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: _doorNoController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your door no';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    " Street ,Sector, Village",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: _streetController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your street address';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    " Landmark",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: TextFormField(
                        controller: _LandmarkController,
                        decoration: const InputDecoration(
                          hintText: '    Near Chaitanya School',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your city';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    " Pincode",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "    6 digits [0-9] pincode",
                          border: InputBorder.none,
                        ),
                        controller: _postalCodeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your state/province';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Town / City',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: TextFormField(
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        controller: _cityController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your postal code';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'State',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: TextFormField(
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        controller: _stateController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your state name:';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.isEditing) {
                        _updateAddress();
                      } else {
                        _updateAddress();
                      }
                    },
                    child: Text(widget.isEditing ? 'Save' : 'Submit'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
