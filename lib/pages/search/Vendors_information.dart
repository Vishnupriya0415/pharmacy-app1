// ignore_for_file: unused_local_variable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:gangaaramtech/pages/cart/CartPage1.dart';
import 'package:gangaaramtech/pages/cart/CartProvider.dart';
import 'package:provider/provider.dart';

class VendorListScreen extends StatefulWidget {
  final String searchQuery;
  const VendorListScreen({Key? key, required this.searchQuery})
      : super(key: key);

  @override
  _VendorListScreenState createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? selectedVendorUid;
  List<String> medicineList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vendors List',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<User?>(
        future: _auth.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Text('User not logged in.');
          }

          User? user = snapshot.data;
          return fetchVendors();
        },
      ),
    );
  }

  Widget fetchVendors() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('vendors').snapshots(),
      builder: (context, usersSnapshot) {
        if (usersSnapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (usersSnapshot.hasError) {
          return Text('Error: ${usersSnapshot.error}');
        }

        final documents = usersSnapshot.data?.docs;

        if (documents == null || documents.isEmpty) {
          return const Text('No user details found.');
        }

        return Card(
          child: ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final userData = documents[index].data() as Map<String, dynamic>;
              final username = userData['Name'] ?? 'N/A';
              final email = userData['email'] ?? 'N/A';
              final pharmacyName = userData['pharmacyName'] ?? 'N/A';
              final phone = userData['phone'] ?? 'N/A';
              final vendorUid = userData['uid'] ?? 'N/A';

              return GestureDetector(
                onTap: () {
                  final cartProvider =
                      Provider.of<CartProvider>(context, listen: false);
                  cartProvider.setSelectedVendorUid(vendorUid);
                  cartProvider.setPharmacyName(pharmacyName);
                  // Check if the vendor is already selected and add medicine accordingly
                  if (cartProvider.selectedVendorUid == vendorUid) {
                    // If the vendor is already selected, add the medicine to the existing list
                    cartProvider.addToMedicineList(widget.searchQuery);
                  } else {
                    // If a different vendor is selected, update the selected vendor and start a new list
                    cartProvider.setSelectedVendorUid(vendorUid);
                    cartProvider.setMedicineList([widget.searchQuery]);
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(
                        pharmacyName: pharmacyName,
                        medicineList: medicineList,
                        vendorId: vendorUid,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300]!.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Card(
                    child: ListTile(
                      title: Text("Search: ${widget.searchQuery}"),
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              Text(' $username'),
                              const Spacer(),
                            //  Text(' $email'),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Pharmacy: $pharmacyName"),
                              const Spacer(),
                              Text("Phone: $phone")
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
