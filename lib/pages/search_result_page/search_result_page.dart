// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MedicalStoreListScreen extends StatefulWidget {
  const MedicalStoreListScreen({super.key});

  @override
  State<MedicalStoreListScreen> createState() => _MedicalStoreListScreenState();
}

class _MedicalStoreListScreenState extends State<MedicalStoreListScreen> {
  List<Map<String, dynamic>> pharmacyData = [];

  @override
  void initState() {
    super.initState();
    fetchMedicalStores();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ElevatedButton(
            //   onPressed: () {
            //     fetchMedicalStores();
            //   },
            //   child: const Text('Search Medical Stores'),
            // ),
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
      print("Error: $e");
    }
  }
}
