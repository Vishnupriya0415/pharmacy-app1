// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MedicalStoreListScreen extends StatefulWidget {
  const MedicalStoreListScreen({Key? key}) : super(key: key);

  @override
  State<MedicalStoreListScreen> createState() => _MedicalStoreListScreenState();
}

class _MedicalStoreListScreenState extends State<MedicalStoreListScreen> {
  List<Map<String, dynamic>> pharmacyData = [];
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    // _getCurrentLocation();
    fetchInitialValueFromFirestore();
  }

  Future<void> fetchInitialValueFromFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    DocumentReference<Map<String, dynamic>> snapshot =
        firestore.collection('users').doc(uid);
    DocumentSnapshot<Map<String, dynamic>> data = await snapshot.get();
    double initialValue1 = data['latitude']?.toDouble() ?? 0.0;
    double initialValue2 = data['longitude']?.toDouble() ?? 0.0;

    // Set the initial position
    setState(() {
      currentPosition = Position(
        latitude: initialValue1,
        longitude: initialValue2,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );
    });

    // Fetch medical stores
    fetchMedicalStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: pharmacyData.length,
                itemBuilder: (context, index) {
                  final data = pharmacyData[index];
                  final name = data["name"] ?? "N/A";
                  final tel = data["tel"] ?? "N/A";
                  final formattedAddress =
                      data["location"]["formatted_address"] ?? "N/A";

                  return Card(
                    child: ListTile(
                      title: Text(name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Phone Number: $tel"),
                          Text("Address: $formattedAddress"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchMedicalStores() async {
    if (currentPosition == null) {
      print('Error: Current position is not available.');
      return;
    }

    final latitude = currentPosition!.latitude;
    final longitude = currentPosition!.longitude;

    final url =
        "https://api.foursquare.com/v3/places/search?query=pharmacy&ll=$latitude%2C$longitude&radius=10000&fields=name%2Clocation%2Ctel%2Cemail%2Cwebsite%2Chours&sort=RELEVANCE&limit=30";

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
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
