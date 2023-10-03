// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/Vendor/OrderManagement.dart';
import 'package:gangaaramtech/Vendor/Order_provider.dart';
import 'package:gangaaramtech/repository/firestorefunctions.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class MedicineDetails {
  final String medicineName;
  final String dosage;
  final String tablets;
  final String description;
  final String shippingMethod;
  final String cost;
  final List<String> imagePaths;

  MedicineDetails({
    required this.medicineName,
    required this.dosage,
    required this.tablets,
    required this.description,
    required this.shippingMethod,
    required this.cost,
    required this.imagePaths,
  });
}

class MedicineDetailsPage extends StatefulWidget {
  final MedicineDetails medicineDetails;

  const MedicineDetailsPage({super.key, required this.medicineDetails});

  @override
  State<MedicineDetailsPage> createState() => _MedicineDetailsPageState();
}

class _MedicineDetailsPageState extends State<MedicineDetailsPage> {
  final PageController _pageController = PageController();
  String? selectedPharmacy;
  List<Map<String, dynamic>> pharmacyData = [];
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map<String, dynamic> userData = {};
  
  @override
  void initState() {
    super.initState();
    fetchMedicalStores();
    fetchUserData();
  }
 Future<void> fetchUserData() async {
    Map<String, dynamic> data = await FireStoreFunctions().getUserData();
    setState(() {
      userData = data;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void updateSelectedPharmacy(String pharmacyName) {
      setState(() {
        selectedPharmacy = pharmacyName;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Details of medicine',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Set the color of the text to blue
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ), // Use appropriate icon for back arrow
          onPressed: () {
            Navigator.pop(
                context); // Go back to the previous screen on arrow button press
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: _pageController,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.medicineDetails.imagePaths.length,
                      itemBuilder: (context, index) {
                        return AspectRatio(
                          aspectRatio: 10 / 9,
                          child: Image.asset(
                            widget.medicineDetails.imagePaths[index],
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Medicine Name: ${widget.medicineDetails.medicineName}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Dosage: ${widget.medicineDetails.dosage}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'tablets ${widget.medicineDetails.tablets}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Description: ${widget.medicineDetails.description}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),

              // Additional content related to shipping
              const Text(
                'Shipping Information:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Shipping Method: ${widget.medicineDetails.shippingMethod}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Cost: ${widget.medicineDetails.cost}', // Display the Cost here
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Select a pharmacy to place your order:",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Tooltip(
                  message:
                      'The provided pharmacies are there to help you with your health needs and conviniently located near you',
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Set the background color
                      borderRadius:
                          BorderRadius.circular(20), // Add rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButton<String>(
                      value: selectedPharmacy,
                      items: pharmacyData.map((store) {
                        final storeName = store["name"] as String;
                        final storeLocation =
                            store["location"]["formatted_address"] as String;
                        final storeValue = '$storeName ($storeLocation)';
                        return DropdownMenuItem<String>(
                          value: storeValue,
                          child: Text(storeName),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        updateSelectedPharmacy(newValue!);
                      },
                      icon: const Icon(
                          Icons.arrow_drop_down), // Add a dropdown icon
                      isExpanded:
                          true, // Ensure the dropdown button expands to fit content
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),

              ElevatedButton(
                onPressed: () {
                  print("added to cart");
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.blue),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                      Colors.white), // Set the background color
                  minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, 50)),
                ),
                child: const Text(
                  "Add to cart",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Set the color of the text to blue
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                 onPressed: () {
                   final orderProvider = Provider.of<OrderProvider>(context, listen: false); // Obtain the instance

                   final newOrder = MyOrder(
      id: UniqueKey().toString(), 
      // Generate a unique order ID
    medicineNames:[widget.medicineDetails.medicineName],
      customerName: '${userData['Name']}', 
      totalAmount: widget.medicineDetails.cost, 
      isAccepted: false, 
   // pharmacyName: selectedPharmacy,
    );

    // Add the new order to the OrderProvider
    orderProvider.addOrder(newOrder);

    // Display a SnackBar to confirm the order placement
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order placed successfully'),
        duration: Duration(seconds: 2),
      ),
    );
    },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.blue),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                      Colors.blue), // Set the background color
                  minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, 50)),
                ),
                child: const Text(
                  'Pay',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set the color of the text to blue
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchMedicalStores() async {
    const url =
        "https://api.foursquare.com/v3/places/search?query=pharmacy&ll=13.6447653%2C79.4175508&radius=10000&fields=name%2Clocation%2Ctel%2Cemail%2Cwebsite%2Chours&sort=RELEVANCE&limit=30";

    final headers = {
      "accept": "application/json",
      "Authorization": "fsq3LPvbSdx96rSXZgsqmzDM3f/3KxqosKh/xuQZ2WT3MU8="
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final results = responseData["results"];

        // Filter out entries without valid phone numbers and addresses
        final validMedicalStores = List<Map<String, dynamic>>.from(results)
            .where((store) =>
                store["tel"] != null &&
                store["tel"] != "N/A" &&
                store["location"]["formatted_address"] != null &&
                store["location"]["formatted_address"] != "N/A")
            .toList();

        setState(() {
          pharmacyData = validMedicalStores;
        });
      }
    } catch (e) {
      //  print("Error: $e");
    }
  }
}
