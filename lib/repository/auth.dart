// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/pages/authentication/otp/otp.dart';
import 'package:gangaaramtech/pages/authentication/phone_input/phonenumberinput.dart';
import 'package:gangaaramtech/pages/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Auth extends ChangeNotifier {
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
      // Sign in with the credential
      final UserCredential userCredentials =
          await FirebaseAuth.instance.signInWithCredential(credential);
      // Get the user details
      final User? user = userCredentials.user;
      if (user != null) {
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        final userDocSnapshot = await userDoc.get();
        final bool userDocExists = userDocSnapshot.exists;
        final Map<String, dynamic>? userData = userDocExists
            ? userDocSnapshot.data() as Map<String, dynamic>
            : null;
        final String? mobileNumber = userData?['mobileNumber'];

        final sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.clear();
        sharedPreferences.setString('userType', 'medicalshop');

        if (userDocExists) {
          await userDoc.update({'name': user.displayName});

          if (mobileNumber == null || mobileNumber == '') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PhoneNumberInput(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
            );
          }
        } else {
          String? mtoken = await FirebaseMessaging.instance.getToken();
          await userDoc.set({
            'uid': user.uid,
            'email': user.email,
            'createdAt': DateTime.now().toString(),
            'lastSignIn': DateTime.now().toString(),
            'Name': user.displayName,
            'mtoken': mtoken.toString(),
            'phone': '',
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PhoneNumberInput(),
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

  // Phone Number Verification
  // void phoneVerification(BuildContext context, String phoneNumber) async {
  //   try {
  //     await _firebaseAuth.verifyPhoneNumber(
  //       phoneNumber: phoneNumber,
  //       verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
  //         await _firebaseAuth.signInWithCredential(phoneAuthCredential);
  //       },
  //       verificationFailed: (error) {
  //         // throw Exception(error.message);
  //         if (error.code == 'invalid-phone-number') {
  //           // Show the "invalid phone number" error using SnackBar
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(
  //                 content: Text('The provided phone number is not valid.')),
  //           );
  //         } else {
  //           // Show the "too many requests" error using SnackBar
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(
  //                 content:
  //                     Text('Too many requests, please try again later...')),
  //           );
  //         }
  //       },
  //       codeSent: (verificationId, forceResendingToken) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => OtpVerify(
  //               verificationId: verificationId,
  //             ),
  //           ),
  //         );
  //       },
  //       codeAutoRetrievalTimeout: (verificationId) {},
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(e.message.toString())),
  //     );
  //   }
  // }
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
              builder: (context) => OtpVerify(
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
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);

      User? user = (await _firebaseAuth.signInWithCredential(creds)).user;

      if (user != null) {
        _uid = user.uid;
        final sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.clear();
        sharedPreferences.setString('userType', 'medicalshop');
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
        await firestore.collection("users").doc(uid).get();
    if (snapshot.exists) {
      print("USER EXISTS");
      User currentUser = FirebaseAuth.instance.currentUser!;
      await firestore
          .collection('users')
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
