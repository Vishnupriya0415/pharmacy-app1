// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

class OrderPlacementProvider extends ChangeNotifier {
  String selectedAddress = '';

  void setAddress(String address) {
    selectedAddress = address;
    notifyListeners();
  }
}
