// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/Vendor/VHome/VendorHome.dart';
import 'package:gangaaramtech/Vendor/VendorInforScreens/VendorInfo2.dart';
import 'package:gangaaramtech/Vendor/authentication/VOtp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class VAuth extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? _uid;
  String get uid => _uid!;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // User Stream
  Stream<User?> currentUserStream() {
    return _firebaseAuth.authStateChanges();
  }

  // Google Sign In
  signInWithGoogle(context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential vendorCredentials =
          await FirebaseAuth.instance.signInWithCredential(credential);
          //get the user details
      final User? vendor = vendorCredentials.user;
      if (vendor != null) {
        final userDoc =
            FirebaseFirestore.instance.collection('vendors').doc(vendor.uid);
          //  print(uid);
        final userDocSnapshot = await userDoc.get();
        final bool userDocExists = userDocSnapshot.exists;
        final Map<String, dynamic>? vendorData = userDocExists
            ? userDocSnapshot.data() as Map<String, dynamic>
            : null;
        final String? mobileNumber = vendorData?['mobileNumber'];

        final sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.clear();
        
        String email = vendor.email ?? ""; // Assign an empty string if email is null


        if (userDocExists) {
          await userDoc.update({'name': vendor.displayName});
         await userDoc.update({'email': vendor.email});

          if (mobileNumber == null || mobileNumber == '') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>   VendorInfoScreen(email: email),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>const  VendorHome(),
              ),
            );
          }
        } else {
          String? mtoken = await FirebaseMessaging.instance.getToken();
          await userDoc.set({
            'uid': vendor.uid,
            'email': vendor.email,
            'createdAt': DateTime.now().toString(),
            'lastSignIn': DateTime.now().toString(),
            'Name': vendor.displayName,
            'mtoken': mtoken.toString(),
            'phone': '',
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  VendorInfoScreen(email: vendor.email,),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        AlertDialog(
          title: const Text('Error'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'An account with a different sign-in method already exists for the same email address.',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      } else if (e.code == 'invalid-credential') {
        AlertDialog(
          title: const Text('Error'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'The supplied auth credential is malformed or has expired.',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      } else {
        AlertDialog(
          title: const Text('Error'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('An error occurred while signing in with Google.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    }
  }

    Future<void> phoneVerification(
      BuildContext context, String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await _firebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          if (error.code == 'invalid-phone-number') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('The provided phone number is not valid.')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                      Text('Too many requests, please try again later...')),
            );
          }
        },
        codeSent: (verificationId, forceResendingToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VOtpVerify(
                verificationId: verificationId,
                phone: phoneNumber,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message.toString())),
      );
    }
  }

  // verify otp
  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String vendorOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: vendorOtp);

      User? vendor = (await _firebaseAuth.signInWithCredential(creds)).user;

      if (vendor != null) {
        _uid = vendor.uid;
        final sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.clear();
        sharedPreferences.setString('userType', 'vendors');
        onSuccess();
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      SnackBar(content: Text(e.message.toString()));
      _isLoading = false;
      notifyListeners();
    }
  }

  // check exisiting user
  Future<bool> checkExistingUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot =
        await firestore.collection('vendors').doc(uid).get();
    if (snapshot.exists) {
      print("USER EXISTS");
      User currentUser = FirebaseAuth.instance.currentUser!;
      await firestore
          .collection('vendors')
          .doc(currentUser.uid)
          .update({'lastSignIn': DateTime.now()});
      return true;
    } else {
      print("NEW USER");
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.clear();
    } catch (e) {
      throw Exception(e);
    }
  }
}
