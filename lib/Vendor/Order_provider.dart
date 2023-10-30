// ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
class MyOrder {
  final String id;
  final List<String> medicineNames;
  final String customerName;
  final String totalAmount;
  // final String? pharmacyName;
  bool isAccepted; // Flag to track acceptance status

  MyOrder({
    required this.id,
    //  required this.pharmacyName,
    required this.medicineNames,
    required this.customerName,
    required this.totalAmount,
    required this.isAccepted,
  });
}


class OrderProvider extends ChangeNotifier {
    final List<MyOrder> _orders = [];
  
final StreamController<List<MyOrder>> _orderController = StreamController<List<MyOrder>>();

  Stream<List<MyOrder>> get orderStream => _orderController.stream;

  
  @override
  void dispose() {
    super.dispose();
    _orderController.close();
  }
  List<MyOrder> get orders => _orders;

  void addOrder(MyOrder order) {
    _orders.add(order);
    notifyListeners();
  }
}