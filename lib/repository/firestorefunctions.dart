// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FireStoreFunctions {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  Future<Map<String, dynamic>> getUserData() async {
    try {
      User currentUser = auth.currentUser!;
      DocumentSnapshot userSnapshot =
          await firestore.collection('users').doc(currentUser.uid).get();
      return userSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
// Handle any errors here
      print('Error fetching user data:  $e');
      return {}; // Return an empty map or handle the error as needed
    }
  }

Future<Map<String, dynamic>> getVendorData() async {
    try {
      User currentUser = auth.currentUser!;
      DocumentSnapshot userSnapshot =
          await firestore.collection('vendors').doc(currentUser.uid).get();
      return userSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
// Handle any errors here
      print('Error fetching user data:  $e');
      return {}; // Return an empty map or handle the error as needed
    }
  }

  Future<String> updatePhoneNumber({
    required String phoneNumber,
  }) async {
    String res = 'Some Error Occurred';
    try {
      if (phoneNumber.isNotEmpty) {
        User currentUser = auth.currentUser!;
        await firestore
            .collection('users')
            .doc(currentUser.uid)
            .update({'phone': phoneNumber});
        res = 'success';
      } else {
        res = 'Please enter your mobile number';
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        res = e.message ?? 'Some Error Occurred';
      } else {
        res = e.toString();
      }
    }
    return res;
  }

Future<String> updateVPhoneNumber({
    required String phoneNumber,
  }) async {
    String res = 'Some Error Occurred';
    try {
      if (phoneNumber.isNotEmpty) {
        User currentUser = auth.currentUser!;
        await firestore
            .collection('vendors')
            .doc(currentUser.uid)
            .update({'phone': phoneNumber});
        res = 'success';
      } else {
        res = 'Please enter your mobile number';
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        res = e.message ?? 'Some Error Occurred';
      } else {
        res = e.toString();
      }
    }
    return res;
  }

  Future<String> updateUserData({
    required String name,
    required String email,
    required String phone,
  }) async {
    String res = 'Some Error Occurred';
    try {
      if (name.isNotEmpty && email.isNotEmpty && phone.isNotEmpty) {
        User currentUser = auth.currentUser!;
        String? mtoken = await FirebaseMessaging.instance.getToken();
        await firestore.collection('users').doc(currentUser.uid).set({
          'Name': name,
          'email': email,
          'phone': phone,
          'uid': currentUser.uid,
          'createdAt': DateTime.now().toString(),
          'lastSignIn': DateTime.now().toString(),
          'mtoken': mtoken.toString(),
        });
        res = 'success';
      } else {
        res = 'Please enter your details';
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        res = e.message ?? 'Some Error Occurred';
      } else {
        res = e.toString();
      }
    }
    return res;
  }

Future<String> updateVendorsData({
    required String name,
    required String email,
    required String phone,
    required String pharmacyName,
    required String doorNo,
    required String street,
    required String city,
    required String state,
    required String postalCode,
    String? profileImageUrl,
  }) async {
    String res = 'Some Error Occurred';
    try {
      if (name.isNotEmpty && email.isNotEmpty && phone.isNotEmpty) {
        User currentUser = auth.currentUser!;
        String? mtoken = await FirebaseMessaging.instance.getToken();
        Map<String, dynamic> address = {
        'doorNo': doorNo,
        'street': street,
        'city': city,
        'state': state,
        'postalCode': postalCode,
      };
        await firestore.collection('vendors').doc(currentUser.uid).set({
          'Name': name,
          'email': email,
          'phone': phone,
          'uid': currentUser.uid,
          'createdAt': DateTime.now().toString(),
          'lastSignIn': DateTime.now().toString(),
          'mtoken': mtoken.toString(),
          'pharmacyName':pharmacyName,
          'address': address,
          'profileImageUrl':profileImageUrl
        });
        res = 'success';
      } else {
        res = 'Please enter your details';
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        res = e.message ?? 'Some Error Occurred';
      } else {
        res = e.toString();
      }
    }
    return res;
  }

  
 }
