// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

// class MedicineDetails {
//   final String medicineName;
//   final String dosage;
//   final String tablets;
//   final String description;
//   final String shippingMethod;
//   final String cost; // Add the Cost parameter here
//   final List<String> imagePaths;

//   MedicineDetails({
//     required this.medicineName,
//     required this.dosage,
//     required this.tablets,
//     required this.description,
//     required this.shippingMethod,
//     required this.cost, // Make sure to include the Cost parameter here
//     required this.imagePaths,
//   });
// }

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

  @override
  Widget build(BuildContext context) {
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
}
