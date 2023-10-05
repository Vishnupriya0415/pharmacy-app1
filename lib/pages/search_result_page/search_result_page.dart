// ignore_for_file: library_private_types_in_public_api, avoid_web_libraries_in_flutter, annotate_overrides, override_on_non_overriding_member, prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/Items_in_cart.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/SelectedDataProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SelectedData {
  final String medicineName;
  final Map<String, dynamic> pharmacyData;
  SelectedData({required this.medicineName, required this.pharmacyData});
  //final selectedDataProvider = Provider.of<SelectedDataProvider>(context, listen: false);
  //selectedDataProvider.setSelectedData(medicineName, pharmacyData);
}

class MedicalStoreListScreen extends StatefulWidget {
  final String searchQuery;

  const MedicalStoreListScreen({Key? key, required this.searchQuery, required void Function(dynamic selectedMedicine) onMedicineSelected})
      : super(key: key);

  @override
  _MedicalStoreListScreenState createState() => _MedicalStoreListScreenState();
}

class _MedicalStoreListScreenState extends State<MedicalStoreListScreen> {
  List<Map<String, dynamic>> pharmacyData = [];

  @override
  void initState() {
    super.initState();
    fetchMedicalStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Search results for prescription',
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            Text(
              'Number of pharmacies: ${pharmacyData.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Consumer<SelectedDataProvider>(
                  builder: (context, selectedDataProvider, child) {
                return ListView.builder(
                  itemCount: pharmacyData.length,
                  itemBuilder: (context, index) {
                    final data = pharmacyData[index];
                    final name = data["name"] ?? "N/A";
                    final address = data["address"] ?? "N/A";

                    return GestureDetector(
                      onTap: () {
                         final selectedMedicalShop = MedicalShop(
                            name: name,
                            medicines: [
                              Medicine(
                                name: widget.searchQuery,
                                price: 0.0, // Set the initial price to 0
                                quantity: 0,
                                pharmacyName: '' // Set the initial quantity to 0
                              ),
                            ],
                          );
                          selectedDataProvider.addMedicalShop(selectedMedicalShop);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartPage(),
                            ),
                          );
                        },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
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
                              title: Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: Column(
                                children: [
                                  const SizedBox(height: 10.0),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(' ${widget.searchQuery}')),
                                  Text(
                                    'Address: $address',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchMedicalStores() async {
    const url =
        "https://api.foursquare.com/v3/places/search?query=pharmacy&ll=13.6447653%2C79.4175508&radius=5000&fields=name%2Clocation%2Ctel%2Cemail%2Cwebsite%2Chours&sort=RELEVANCE&limit=30";

    final headers = {
      "accept": "application/json",
      "Authorization": "fsq3LPvbSdx96rSXZgsqmzDM3f/3KxqosKh/xuQZ2WT3MU8="
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final results = responseData["results"];

        final validMedicalStores = List<Map<String, dynamic>>.from(results)
            .where((store) =>
                store["tel"] != null &&
                store["tel"] != "N/A" &&
                store["location"]["formatted_address"] != null &&
                store["location"]["formatted_address"] != "N/A")
            .map((store) {
          final medicines = [
            {"name": "Paracetamol", "dosage": "1 tablet"},
            {"name": "Ibuprofen", "dosage": "1 tablet"},
            // Add more medicines and dosages
          ];

          return {
            "name": store["name"],
            "address": store["location"]["formatted_address"],
            "medicines": medicines,
          };
        }).toList();

        setState(() {
          pharmacyData = validMedicalStores;
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error: $e");
    }
  }
}
