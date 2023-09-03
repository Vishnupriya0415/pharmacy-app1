import 'package:flutter/material.dart';

class MedicineSearchPage extends StatefulWidget {
  const MedicineSearchPage({super.key});

  @override
  State<MedicineSearchPage> createState() => _MedicineSearchPageState();
}

class _MedicineSearchPageState extends State<MedicineSearchPage> {
  final TextEditingController _medicineController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String cameraResult = '';
  String locationResult = '';

  void _handleCameraResult(String result) {
    setState(() {
      cameraResult = result;
      _medicineController.text = result;
    });
  }

  @override
  void dispose() {
    _medicineController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search for medicine',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black, // Set the color of the text to black
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ), // Use appropriate icon for the back arrow
          onPressed: () {
            Navigator.pop(
                context); // Go back to the previous screen on arrow button press
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _locationController,
                    onChanged: (value) {
                      // Your logic to handle location search here
                    },
                    decoration: const InputDecoration(
                      labelText: 'Search Location',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.location_on,
                    size: 50,
                  ),
                  onPressed: () {
                    // Handle the location search option here
                    // For demonstration purposes, I'm setting the location result manually.
                    // You should implement your location search functionality here and set the result accordingly.
                    setState(() {
                      locationResult = 'Location: XYZ';
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _medicineController,
                    onChanged: (value) {
                      // Your logic to handle medicine search here
                    },
                    decoration: const InputDecoration(
                      labelText: 'Search Medicine',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () {
                    // Handle the camera option here
                    // For demonstration purposes, I'm setting the camera result manually.
                    // You should implement your camera functionality here and set the result accordingly.
                    _handleCameraResult('Medicine X');
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Text('Medicine Found:'),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextFormField(
                    controller: _medicineController,
                    onChanged: (value) {
                      setState(() {
                        cameraResult =
                            ''; // Reset camera result if the user modifies the medicine name manually
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Medicine Name',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Text('Number of Tablets:'),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    onChanged: (value) {
                      // Handle the quantity input here
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Quantity',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
