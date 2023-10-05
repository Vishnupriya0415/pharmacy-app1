// ignore_for_file: prefer_final_fields

import 'package:flutter/foundation.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/OrderPlacing.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/SelectedDataProvider.dart';

class OrderDataProvider extends ChangeNotifier {
  String pharmacyName = '';
  List<Medicine> medicines = [];
  List<OrderItem> _currentOrder = [];

  void setOrderData(String pharmacyName, List<Medicine> medicines) {
    this.pharmacyName = pharmacyName;
    this.medicines = medicines;
    notifyListeners();
  }
  List<OrderItem> get currentOrder => _currentOrder;

  void addToCurrentOrder(OrderItem item) {
    _currentOrder.add(item);
    notifyListeners();
  }
  void clearCurrentOrder() {
    // Implement the logic to clear the current order here
    // For example, you can set the list of medicines to an empty list
    medicines.clear();

    // Notify listeners that the data has changed
    notifyListeners();
  }

  void removeFromCurrentOrder(OrderItem item) {
    _currentOrder.remove(item);
    notifyListeners();
  }
}
