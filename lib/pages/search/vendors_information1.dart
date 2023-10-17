// ignore_for_file: unused_local_variable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
            final vendorUid = userData['Uid'] ?? 'N/A';

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
                        Text('Name: $username'),
                        Text('Email: $email'),
                        Text('Phone: $phone'),
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
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text('Send Image to $pharmacyName?'),
        content: const Text(
            'Are you sure you want to send the image to this pharmacy?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      ),
    );
  }
}