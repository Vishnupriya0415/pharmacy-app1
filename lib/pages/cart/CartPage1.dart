// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:gangaaramtech/pages/cart/CartItemsPage.dart';
import 'package:gangaaramtech/pages/cart/CartProvider.dart';
import 'package:gangaaramtech/pages/search/Vendors_information.dart';
import 'package:gangaaramtech/pages/search/search_page1.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  final String pharmacyName;
  final String vendorId;

  const CartPage({
    Key? key,
    required this.pharmacyName,
    required List<String> medicineList,
    required this.vendorId,
  }) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Set<String> selectedMedicines = {}; // Store the selected medicines

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final List<String> cartMedicineList = cartProvider.medicineList;

    return Scaffold(
      body: SafeArea(
        child: Card(
          elevation: 4,
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(" ${widget.pharmacyName}"),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (selectedMedicines.isNotEmpty) {
                        // Navigate to the VendorListScreen with the selected medicine
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VendorListScreen(searchQuery: selectedMedicines.first),
                          ),
                        );
                      } else {
                           ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("Please select medicines to proceed."),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Change Pharmacy",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cartMedicineList.length,
                  itemBuilder: (context, index) {
                    final medicineName = cartMedicineList[index];
                    return ListTile(
                      title: Text(medicineName),
                      leading: Checkbox(
                        value: selectedMedicines.contains(medicineName),
                        onChanged: (isChecked) {
                          setState(() {
                            if (isChecked != null) {
                              if (isChecked) {
                                selectedMedicines.add(medicineName);
                              } else {
                                selectedMedicines.remove(medicineName);
                              }
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 3,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the search page to add another medicine
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPage(
                            onMedicineSelected: (selectedMedicine) {
                              // Use the cartProvider to add the selected medicine to the list
                              cartProvider.addToMedicineList(selectedMedicine);
                              Navigator.pop(context); // Close the search page
                            },
                          ),
                        ),
                      );
                    },
                     style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            Colors.blue, // Text color
                                        padding: const EdgeInsets.all(
                                            10.0), // Button padding
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10), // Rounded corners
                                        ),
                                        elevation: 5, // Button shadow
                                      ),
                    child: const Text("+ Medicine"),
                  ),
                  const Spacer(),

                  ElevatedButton(
                    onPressed: () {
                          if (selectedMedicines.isEmpty) {
          // Display a SnackBar message if no medicines are selected
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please select medicines to proceed."),
            ),
          );
        } else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartItemsPage(
                            pharmacyName: widget.pharmacyName,
                            cartMedicineList: selectedMedicines.toList(),
                            vendorUid: widget.vendorId,
                          ),
                        ),
                      );
                    }
                    },
                     style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            Colors.blue, // Text color
                                        padding: const EdgeInsets.all(
                                            10.0), // Button padding
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10), // Rounded corners
                                        ),
                                        elevation: 5, // Button shadow
                                      ),
                    child: const Text("Move to Cart"),
                  ),
                ],
              ),
              const SizedBox(height: 14), // Add space between rows
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
