//import 'package:flutter/foundation.dart';

class PrescriptionOrder {
  final String prescriptionImageUrl;
  final String orderId;
  final double taxes;
  final double total;
  final String userUid;
  final String pharmacyName;
  final String status;
  final DateTime orderedTime;
  final String paymentMethod;

  Map<String, dynamic> address;

  PrescriptionOrder(
      {required this.address,
      required this.paymentMethod,
      required this.orderId,
      required this.status,
      required this.taxes,
      required this.total,
      required this.userUid,
      required this.pharmacyName,
      required this.prescriptionImageUrl,
      required this.orderedTime, required String imageUrl, required String vendorUid});

  Map<String, dynamic> toMap() {
    return {
      'orderedTime': orderedTime,
      'status': status,
      'orderId': orderId,
      'taxes': taxes,
      'total': total,
      'userUid': userUid,
      'address': address,
      'pharmacyName': pharmacyName,
      'paymentMethod': paymentMethod,
      'prescriptionImageUrl': prescriptionImageUrl
    };
  }
}
