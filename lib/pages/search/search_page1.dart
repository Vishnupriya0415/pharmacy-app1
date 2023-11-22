// ignore_for_file: library_private_types_in_public_api, unused_import

import 'package:flutter/material.dart';
import 'package:gangaaramtech/pages/search/Vendors_information.dart';
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
                        // Navigate to the "vendor list screen page" with the selected medicine
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VendorListScreen(searchQuery: searchQuery),
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


