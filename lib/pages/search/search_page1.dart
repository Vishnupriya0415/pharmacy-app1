// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gangaaramtech/pages/cart/CartProvider.dart';
import 'package:gangaaramtech/pages/home/home.dart';
import 'package:gangaaramtech/pages/cart/CartPage1.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required Null Function(dynamic selectedMedicine) onMedicineSelected}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Page',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
            );
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: Colors.black, width: 1.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (searchQuery) {
                        // Get the pharmacyName and selectedVendorUid from the CartProvider
                        final cartProvider = Provider.of<CartProvider>(context, listen: false);
                        final pharmacyName = cartProvider.pharmacyName;
                        final vendorId = cartProvider.selectedVendorUid ?? 'N/A';

                        // Add the searched medicine to the medicine list
                        cartProvider.addToMedicineList(searchQuery);

                        // Trigger navigation when the user submits the search
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartPage(
                              pharmacyName: pharmacyName, // Use the pharmacyName from CartProvider
                              medicineList: [searchQuery], // Add the searched medicine to the list
                              vendorId: vendorId, // Use the selectedVendorUid from CartProvider
                            ),
                          ),
                        );
                      },
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt_outlined, size: 40),
                    onPressed: () {
                      // Implement camera functionality here
                      // This button can be used to take a picture or open the gallery.
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            const Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search),
                  Text(
                    "Find Your Health Solution:",
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                  Text(
                    "Search for Medicines at Nearby Medical Stores",
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
