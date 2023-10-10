//import 'package:flutter/foundation.dart';

class MyOrder {
  final List<String> medicinesNames;
  final List<double> cost;
  final String orderId;
  final double deliveryCharges;
  final double taxes;
  final double total;
  final String userUid;
  final String pharmacyName;
  final String status;
  final DateTime orderedTime;
  final String paymentMethod;

  MyOrder(
      {required this.medicinesNames,
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
      'taxes': taxes,
      'total': total,
      'userUid': userUid,
  //    'userMtoken': userMtoken,
      'pharmacyName': pharmacyName,
      'cost': cost,
      'paymentMethod': paymentMethod
    };
  }
}
