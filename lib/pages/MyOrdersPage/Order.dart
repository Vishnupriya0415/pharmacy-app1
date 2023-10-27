//import 'package:flutter/foundation.dart';

// ignore_for_file: file_names

class MyOrder {
  final List<String> medicinesNames;
  final List<double> cost;
  final List<int>quantity;
  final String orderId;
  final double deliveryCharges;
  final double taxes;
  final double total;
  final String userUid;
  final String pharmacyName;
  final String status;
  final DateTime orderedTime;
  final String paymentMethod;
  final bool isPrescription;
  Map<String, dynamic> address;
  
  MyOrder(
      {required this.medicinesNames,
      required this.isPrescription,
      required this.quantity,
      required this.address,
      required this.paymentMethod,
      required this.cost,
      required this.deliveryCharges,
      required this.orderId,
      required this.status,
      required this.taxes,
      required this.total,
      required this.userUid,
      required this.pharmacyName,
      required this.orderedTime});

  // Convert the order instance to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'orderedTime': orderedTime,
      'status': status,
      'medicineNames': medicinesNames,
      'orderId': orderId,
      'deliveryCharges': deliveryCharges,
      'quantity': quantity,
      'taxes': taxes,
      'total': total,
      'userUid': userUid,
      'address': address,
      'isPrescription':isPrescription,
  //    'userMtoken': userMtoken,
      'pharmacyName': pharmacyName,
      'cost': cost,
      'paymentMethod': paymentMethod
    };
  }
}
