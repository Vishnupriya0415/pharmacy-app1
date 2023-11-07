// ignore_for_file: unused_local_variable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/Prescription/OrderPlacing/Prescription_Order_placing1/PrescriptionOrderPlacngPage.dart';
import 'package:gangaaramtech/utils/widgets/Alert_dialog.dart';
class VendorListScreen1 extends StatefulWidget {
  final String imageUrl;
  const VendorListScreen1({Key? key, required this.imageUrl}) : super(key: key);

  @override
  _VendorListScreen1State createState() => _VendorListScreen1State();
}

class _VendorListScreen1State extends State<VendorListScreen1> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

        return ListView.builder(
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
                _showConfirmationDialog(pharmacyName, vendorUid);
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
                    title: Text('Vendor: $pharmacyName'),
                    subtitle: Column(

                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Email: $email')),
                        Row(
                          children: [
                            Text('Name: $username'),
                            const Spacer(),
                            Text('Phone: $phone'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showConfirmationDialog(String pharmacyName, String vendorUid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CurvedAlertDialogBox1(
          title: 'Send image to $pharmacyName',
          additionalText:
              'Are you sure you would like to send image to $pharmacyName?',
          onYesPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PrescriptionOrder(
                  vendorUid: vendorUid,
                  imageUrl: widget.imageUrl,
                ),
              ),
            );
            // Handle 'Yes' button press
          },
          onNoPressed: () {
            Navigator.of(context).pop();
            // Handle 'No' button press
          },
        );
      },
    );

    /*showDialog(
      context: context,
      builder: (BuildContext dialogContext) => CurvedAlertDialogBox1(
        title: 'Send Image to $pharmacyName?',
        onClosePressed: () {
          Navigator.of(dialogContext).pop();
        },

        onSubmitPressed: () {
          Navigator.of(dialogContext).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PrescriptionOrder(
                vendorUid: vendorUid,
                imageUrl: widget.imageUrl,
              ),
            ),
          );
        },
        additionalText:
            'Are you sure you would like to send image to $pharmacyName?',
      ),
    );*/
  }

}
