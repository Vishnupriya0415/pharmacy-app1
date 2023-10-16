import 'package:flutter/material.dart';
import 'package:gangaaramtech/pages/cart/CartItemsPage.dart';
import 'package:gangaaramtech/pages/cart/CartProvider.dart';
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
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final List<String> cartMedicineList = cartProvider.medicineList;

    return Scaffold(
      body: SafeArea(
        child: Card(
          elevation: 5,
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Text(" Medines list from ${widget.pharmacyName}"),
                    ],
                  )),
              for (final medicineName in cartMedicineList)
                ListTile(
                  title: Text(' $medicineName'),
                ),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
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
                            },
                          ),
                        ),
                      );
                    },
                    child: const Text("Add Another Medicine"),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartItemsPage(
                            pharmacyName: widget.pharmacyName,
                            cartMedicineList: cartMedicineList,
                            vendorUid: widget.vendorId,
                          ),
                        ),
                      );
                    },
                    child: const Text("Move to cart"),
                  ),
                  const SizedBox(
                    width: 20,
                  )
                ],
              ),
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
