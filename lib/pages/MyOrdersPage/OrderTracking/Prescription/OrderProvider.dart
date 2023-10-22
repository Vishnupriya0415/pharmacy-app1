import 'package:flutter/material.dart';

class OrderCreationState extends ChangeNotifier {
  bool _orderCreationInProgress = false;

  bool get orderCreationInProgress => _orderCreationInProgress;

  set orderCreationInProgress(bool value) {
    _orderCreationInProgress = value;
    notifyListeners();
  }
}
