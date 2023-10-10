import 'package:flutter/material.dart';


class CartItem {
  final String medicineName;
  final int quantity;
  final double cost;

  CartItem({
    required this.medicineName,
    required this.quantity,
    required this.cost,
  });
}
class CartProvider extends ChangeNotifier {
  String? selectedVendorUid;
   List<CartItem> cartItems = []; // List to store cart items
  List<String> medicineList = [];
   String pharmacyName = '';
  List<String> selectedMedicineNames = [];
  

  void setSelectedVendorUid(String vendorUid) {
    selectedVendorUid = vendorUid;
    notifyListeners();
  }
  void removeFromCart(CartItem item) {
    cartItems.remove(item);
    notifyListeners();
  }

void setPharmacyName(String name) {
    pharmacyName = name;
    notifyListeners();
  }

  void addToCart(String medicineName, int quantity, double cost) {
    cartItems.add(CartItem(
      medicineName: medicineName,
      quantity: quantity,
      cost: cost,
    ));
    notifyListeners();
  }


  void addToMedicineList(String medicine) {
    medicineList.add(medicine);
    notifyListeners(); // Notify listeners to update the UI
  }

  void addMedicineName(String medicineName) {
    selectedMedicineNames.add(medicineName);
    notifyListeners();
  }

  void setMedicineList(List<String> medicines) {
    medicineList = medicines;
    notifyListeners(); // Notify listeners to update the UI
  }

  Map<String, int> medicineQuantities = {}; // Initialize with an empty map
  Map<String, double> medicineCosts = {}; // Initialize with an empty map
  double totalCost = 0.0; // Initialize total cost

  void incrementQuantity(String medicineName, double price) {
    if (medicineQuantities.containsKey(medicineName)) {
      medicineQuantities[medicineName] =
          (medicineQuantities[medicineName] ?? 0) +
              1; // Increment quantity if medicine exists
    } else {
      medicineQuantities[medicineName] =
          1; // Initialize quantity if medicine is not in the cart
    }

    if (medicineCosts.containsKey(medicineName)) {
      medicineCosts[medicineName] =
          (medicineCosts[medicineName] ?? 0.0) + price; // Update medicine cost
    } else {
      medicineCosts[medicineName] = price; // Initialize medicine cost
    }

    totalCost += price; // Update total cost
    notifyListeners();
  }

  void decrementQuantity(String medicineName, double price) {
    if (medicineQuantities.containsKey(medicineName)) {
      if (medicineQuantities[medicineName]! > 0) {
        medicineQuantities[medicineName] =
            (medicineQuantities[medicineName] ?? 0) -
                1; // Decrement quantity if quantity is greater than 0

        medicineCosts[medicineName] =
            (medicineCosts[medicineName] ?? 0.0) - price; // Update medicine cost

        totalCost -= price; // Update total cost
        notifyListeners();
      }
    }
  }

  // Add any other necessary methods...
}
