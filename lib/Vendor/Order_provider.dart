//import 'package:application1/Vendor/order_management/OrderManagament.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/Vendor/OrderManagement.dart';
//import 'package:provider/provider.dart';

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
