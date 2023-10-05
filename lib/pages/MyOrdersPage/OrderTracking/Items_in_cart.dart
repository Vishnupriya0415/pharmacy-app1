// ignore_for_file: file_names, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/Address/AddressPage.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/SelectedDataProvider.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/providers/order_data.dart';
import 'package:gangaaramtech/pages/search/search_page1.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedDataProvider =
        Provider.of<SelectedDataProvider>(context);

    Map<String, List<Medicine>> pharmacyMedicinesMap = {};

    for (var medicalShop in selectedDataProvider.selectedMedicalShops) {
      for (var medicine in medicalShop.medicines) {
        var existingMedicines = pharmacyMedicinesMap[medicalShop.name];

        if (existingMedicines != null) {
          var medicinesWithSameName =
              existingMedicines.where((m) => m.name == medicine.name).toList();

          if (medicinesWithSameName.isNotEmpty) {
            for (var existingMedicine in medicinesWithSameName) {
              existingMedicine.quantity += medicine.quantity;
            }
          } else {
            pharmacyMedicinesMap[medicalShop.name]!.add(medicine);
          }
        } else {
          pharmacyMedicinesMap[medicalShop.name] = [medicine];
        }
      }
    }

    return Scaffold(
      body: ListView.builder(
        itemCount: pharmacyMedicinesMap.length,
        itemBuilder: (context, orderIndex) {
          final pharmacyName = pharmacyMedicinesMap.keys.elementAt(orderIndex);
          final medicines = pharmacyMedicinesMap[pharmacyName]!;

          final selectedDataProvider =
              Provider.of<SelectedDataProvider>(context, listen: false);

          final medicalShop = selectedDataProvider.selectedMedicalShops.firstWhere(
            (shop) => shop.name == pharmacyName,
            orElse: () => throw Exception('Pharmacy not found'),
          );

          return Card(
            margin: const EdgeInsets.all(16),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ' $pharmacyName',
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      const Divider(),
                      const Row(
                        children: [
                          Text(
                            "List of medicines",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            " Price",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            " Quantity",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 25,
                          )
                        ],
                      ),
                      Column(
                        children: medicines.map((medicine) {
                          int medIndex = medicines.indexOf(medicine);
                          return GestureDetector(
                            onTap: () {
                              _changeQuantity(context, medicalShop, medicine);
                            },
                            child: ListTile(
                              title: Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      medicine.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: 50,
                                    child: Text('\u20B9${medicine.price}'),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.blue[50],
                                    ),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _decrementQuantity(
                                                context, pharmacyName, medIndex);
                                          },
                                          child: const Icon(
                                            Icons.remove,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 3),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3, vertical: 2),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              color: Colors.white),
                                          child: Text(
                                            '${medicine.quantity}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _incrementQuantity(
                                                context, pharmacyName, medIndex);
                                          },
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Total: \u20B9${_calculateTotalCost(medicines).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                          height:
                              8), // Add some vertical spacing between the rows
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchPage(
                                    onMedicineSelected: (selectedMedicine) {
                                      _addMedicineToCart(
                                        context,
                                        pharmacyName,
                                        selectedMedicine,
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Add Medicine',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              final orderDataProvider =
                                  Provider.of<OrderDataProvider>(context,
                                      listen: false);
                              orderDataProvider.setOrderData(
                                  pharmacyName, medicines);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddressScreen(),
                                ),
                              );
                              // Implement your buy now logic here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Buy now',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  
  void _incrementQuantity(BuildContext context, String pharmacyName, int medIndex) {
  final selectedDataProvider =
      Provider.of<SelectedDataProvider>(context, listen: false);

  final pharmacy = selectedDataProvider.selectedMedicalShops.firstWhere(
    (medicalShop) => medicalShop.name == pharmacyName,
    orElse: () => throw Exception('Pharmacy not found'),
  );

  pharmacy.medicines[medIndex].quantity++;
  selectedDataProvider.notifyListeners();
}

void _decrementQuantity(BuildContext context, String pharmacyName, int medIndex) {
  final selectedDataProvider =
      Provider.of<SelectedDataProvider>(context, listen: false);

  final pharmacy = selectedDataProvider.selectedMedicalShops.firstWhere(
    (medicalShop) => medicalShop.name == pharmacyName,
    orElse: () => throw Exception('Pharmacy not found'),
  );

  final Medicine medicine = pharmacy.medicines[medIndex];

  if (medicine.quantity > 1) {
    medicine.quantity--;
  } else {
    pharmacy.medicines.removeAt(medIndex);
  }

  selectedDataProvider.notifyListeners();
}


  void _changeQuantity(BuildContext context, MedicalShop medicalShop,
      Medicine existingMedicine) {
    // Implement logic to change the quantity of the existing item in the cart.
    // You can open a dialog or a screen for changing the quantity.
    // Here, you can show a dialog to input the new quantity for the existing medicine.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int newQuantity = existingMedicine.quantity;
        return AlertDialog(
          title: const Text('Change Quantity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current Quantity: ${existingMedicine.quantity}'),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'New Quantity'),
                onChanged: (value) {
                  newQuantity =
                      int.tryParse(value) ?? existingMedicine.quantity;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                existingMedicine.quantity = newQuantity;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }

  double _calculateTotalCost(List<Medicine> medicines) {
    double totalCost = 0;
    for (var medicine in medicines) {
      totalCost += medicine.price * medicine.quantity;
    }
    return totalCost;
  }

  void _addMedicineToCart(
      BuildContext context, String pharmacyName, Medicine selectedMedicine) {
    final selectedDataProvider =
        Provider.of<SelectedDataProvider>(context, listen: false);

    final medicalShop = selectedDataProvider.selectedMedicalShops.firstWhere(
      (shop) => shop.name == pharmacyName,
      orElse: () => throw Exception('Pharmacy not found'),
    );

    final existingMedicine = medicalShop.medicines.firstWhere(
      (medicine) => medicine.name == selectedMedicine.name,
      orElse: () => Medicine(
          name: 'Placeholder',
          price: 0.0,
          quantity: 1,
          pharmacyName:
              pharmacyName), // Return placeholder Medicine if the medicine does not exist in the cart.
    );

    if (existingMedicine.name != 'Placeholder') {
      _showSnackbar(context, 'Medicine already in cart');
      _showAlertDialog(
          context, pharmacyName, selectedMedicine, existingMedicine);
    } else {
      // If the medicine and medical shop combination does not exist, add it to the cart.
      medicalShop.medicines.add(selectedMedicine);
      selectedDataProvider.notifyListeners();
    }
  }

  void _showAlertDialog(BuildContext context, String pharmacyName,
      Medicine selectedMedicine, Medicine existingMedicine) {
    final selectedDataProvider =
        Provider.of<SelectedDataProvider>(context, listen: false);

    final medicalShop = selectedDataProvider.selectedMedicalShops.firstWhere(
      (shop) => shop.name == pharmacyName,
      orElse: () => throw Exception('Pharmacy not found'),
    );

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Medicine Already in Cart'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'The medicine ${selectedMedicine.name} from $pharmacyName is already in your cart.'),
                const Text('What would you like to do?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Change Quantity'),
              onPressed: () {
                Navigator.of(context).pop();
                _changeQuantity(context, medicalShop, existingMedicine);
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}