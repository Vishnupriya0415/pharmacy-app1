// ignore_for_file: library_private_types_in_public_api, file_names, unnecessary_null_comparison, non_constant_identifier_names, prefer_const_constructors_in_immutables, unnecessary_this, recursive_getters

import 'package:flutter/material.dart';
import 'package:gangaaramtech/pages/search_result_page/search_result_page.dart';

class Medicine {
  final String name;
  final double price;
  int quantity;

  Medicine({required this.name, required this.price, this.quantity = 1});
}

class Order {
  final String PharmacyName;
  final List<Medicine> medicines;
  Order({required this.PharmacyName, required this.medicines});
}

class CartPage extends StatefulWidget {
  final SelectedData selectedData; 

  CartPage({
  Key? key,
  required this.selectedData,
  required List medicines,
}) : assert(selectedData != null, 'selectedData must not be null'), super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Order> orders = [];

  get searchQuery => widget.selectedData.medicineName;// Initialize an empty list of orders

  @override
  void initState() {
    super.initState();

    // Extract data from the selectedData and create an Order object
    if (widget.selectedData != null) {
      orders.add(
        Order(
          PharmacyName: widget.selectedData.pharmacyData["name"],
          medicines: [
            Medicine(
              name: widget.selectedData.medicineName,
              price: 10.0,
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return orders[index].medicines.isNotEmpty
              ? Card(
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
                              ' ${orders[index].PharmacyName}',
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
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: orders[index].medicines.length,
                              itemBuilder: (context, medIndex) {
                                Medicine medicine =
                                    orders[index].medicines[medIndex];
                                return ListTile(
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
                                          child:
                                              Text('\u20B9${medicine.price}')),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.blue[50],
                                        ),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                _decrementQuantity(
                                                    index, medIndex);
                                              },
                                              child: const Icon(
                                                Icons.remove,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3,
                                                      vertical: 2),
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
                                                    index, medIndex);
                                              },
                                              child: const Icon(Icons.add,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  'Total: \u20B9${_calculateTotalCost(orders[index]).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 24),
                                    child: Text(
                                      'Buy now',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(); // Hide the order when no medicines are left
        },
      ),
    );
  }

  void _incrementQuantity(int orderIndex, int medIndex) {
    setState(() {
      orders[orderIndex].medicines[medIndex].quantity++;
    });
  }

  void _decrementQuantity(int orderIndex, int medIndex) {
    setState(() {
      if (orders[orderIndex].medicines[medIndex].quantity > 0) {
        orders[orderIndex].medicines[medIndex].quantity--;
      }
      if (orders[orderIndex].medicines[medIndex].quantity == 0) {
        orders[orderIndex].medicines.removeAt(medIndex);
      }
      if (orders[orderIndex].medicines.isEmpty) {
        orders.removeAt(orderIndex);
      }
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              MedicalStoreListScreen(searchQuery: searchQuery),
        ),
      );
    });
  }

  double _calculateTotalCost(Order order) {
    double totalCost = 0;
    for (var medicine in order.medicines) {
      totalCost += medicine.price * medicine.quantity;
    }
    return totalCost;
  }
}
