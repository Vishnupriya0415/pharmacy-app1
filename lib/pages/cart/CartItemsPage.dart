// ignore_for_file: sized_box_for_whitespace, unused_local_variable, library_private_types_in_public_api, file_names, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/Address/AddressPage.dart';
import 'package:gangaaramtech/pages/cart/CartProvider.dart';
import 'package:provider/provider.dart';

class CartItemsPage extends StatefulWidget {
  final String pharmacyName;
  final List<String> cartMedicineList;

  const CartItemsPage({
    Key? key,
    required this.pharmacyName,
    required this.cartMedicineList,
    required vendorUid,
  }) : super(key: key);

  @override
  _CartItemsPageState createState() => _CartItemsPageState();
}

class _CartItemsPageState extends State<CartItemsPage> {
  final double pricePerMedicine = 5.0; // Price per medicine (in rupees)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          int totalQuantity = 0; // Initialize total quantity
          double totalCost = 0.0; // Initialize total cost

          return Card(
            child: ListView.builder(
              itemCount: widget.cartMedicineList.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Display the row at the top
                  return Column(
                    children: [
                      Text(
                        'Cart for ${widget.pharmacyName}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Container(
                            width: 95,
                            child: const Text(
                              "List of medicines",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            width: 90,
                          ),
                          const Text(
                            " Quantity",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          const Text(
                            "Total Cost",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  );
                } else if (index == widget.cartMedicineList.length + 1) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Total: ₹${totalCost.toStringAsFixed(2)}", // Display total cost
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              for (String medicineName
                                  in widget.cartMedicineList) {
                                cartProvider.cartItems.add(CartItem(
                                  medicineName: medicineName,
                                  quantity: cartProvider
                                          .medicineQuantities[medicineName] ??
                                      0,
                                  cost: pricePerMedicine,
                                ));
                                cartProvider.notifyListeners();
                              }

                              // Store all medicines in the provider
                              cartProvider
                                  .setMedicineList(widget.cartMedicineList);

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
                      const SizedBox(height: 16), // Add some spacing
                    ],
                  );
                }

                final medicineName = widget.cartMedicineList[index - 1];
                final quantity =
                    cartProvider.medicineQuantities[medicineName] ?? 0;

                // Calculate the cost for this medicine
                final medicineCost = pricePerMedicine * quantity;

                // Update the total quantity and total cost
                totalQuantity += quantity;
                totalCost += medicineCost;

                return ListTile(
                  title: Row(
                    children: [
                      Container(width: 150, child: Text(' $medicineName')),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          cartProvider.decrementQuantity(medicineName,
                              pricePerMedicine); // Decrement quantity
                        },
                        child: const Icon(
                          Icons.remove,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 3, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.white,
                        ),
                        child: Text(
                          '$quantity',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          cartProvider.incrementQuantity(medicineName,
                              pricePerMedicine); // Increment quantity
                        },
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '₹${medicineCost.toStringAsFixed(2)}', // Display medicine cost
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
