// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class VendorPrescriptionOrdersPage extends StatefulWidget {
  final String vendorUid;
  final String pharmacyName;

  const VendorPrescriptionOrdersPage({
    Key? key,
    required this.vendorUid,
    required this.pharmacyName,
  }) : super(key: key);

  @override
  _VendorPrescriptionOrdersPageState createState() =>
      _VendorPrescriptionOrdersPageState();
}

class _VendorPrescriptionOrdersPageState
    extends State<VendorPrescriptionOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prescription Orders for ${widget.pharmacyName}'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'List of Prescription Orders will be displayed here.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            // You can add widgets to display prescription orders here
          ],
        ),
      ),
    );
  }
}
