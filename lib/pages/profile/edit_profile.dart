// Import necessary packages at the top of your file
// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gangaaramtech/pages/common/onboardingscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    fetchInitialValueFromFirestore();
  }

  Future<void> fetchInitialValueFromFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    DocumentReference<Map<String, dynamic>> snapshot =
        firestore.collection('users').doc(uid);
    DocumentSnapshot<Map<String, dynamic>> data = await snapshot.get();
    String initialValue = data['Name']?.toString() ?? '';
    String initialValue1 = data['email']?.toString() ?? '';
    String initialValue2 = data['phone']?.toString() ?? '';
    String initialValue3 = data['address']?.toString() ?? '';
    print(
        'initialValue: $initialValue, $initialValue1, $initialValue2, $initialValue3,');
    setState(() {
      _name.text = initialValue;
      _email.text = initialValue1;
      _phone.text = initialValue2;
      _address.text = initialValue3;
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Profile",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Image.asset(
                            "assets/images/cart.png",
                            height: 24,
                            width: 24,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      ClipOval(
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: Image.asset(
                                "assets/images/user.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                height: 20,
                                width: 80,
                                color: Colors.black.withOpacity(0.3),
                                child: Image.asset(
                                  "assets/images/camera.png",
                                  height: 20,
                                  width: 80,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/edit.png",
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            "Edit Profile",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Hi there ${_name.text}',
                        style: GoogleFonts.lato(
                          fontSize: 28,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      CustomFormInput(
                        label: "Name",
                        controller: _name,
                        focus: _nameFocus,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomFormInput(
                        label: "Email",
                        controller: _email,
                        focus: _emailFocus,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomFormInput(
                        label: "Mobile No",
                        controller: _phone,
                        focus: _phoneFocus,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomFormInput(
                        label: "Address",
                        controller: _address,
                        focus: _addressFocus,
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: const BorderSide(color: Colors.blue),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: const Text("Save",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                  color: Colors.blue)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _showSignOutAlertDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: const BorderSide(color: Colors.white),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text("Sign Out",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                  color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showSignOutAlertDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context, false); // Close the dialog and return false
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Close the dialog and return true after sign-out
                Navigator.pop(context, true);
                // await _performSignOut(context);
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );

    if (result != null && result) {
      _performSignOut(context);
    }
  }

  Future<void> _performSignOut(BuildContext context) async {
    try {
      await _firebaseAuth.signOut();
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
      );
    } catch (e) {
      print('Error signing out: $e');
      // Handle the error, e.g., show a snackbar or an error dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out: $e'),
        ),
      );
    }
  }
}

// class CustomFormInput extends StatelessWidget {
//   const CustomFormInput({
//     Key? key,
//     required String label,
//     required TextEditingController controller,
//   })  : _label = label,
//         _controller = controller,
//         super(key: key);

//   final String _label;
//   final TextEditingController _controller;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 50,
//       padding: const EdgeInsets.only(left: 40),
//       decoration: ShapeDecoration(
//         shape: const StadiumBorder(),
//         color: Colors.grey[300],
//       ),
//       child: TextFormField(
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           labelText: _label,
//           contentPadding: const EdgeInsets.only(
//             top: 10,
//             bottom: 10,
//           ),
//         ),
//         controller: _controller, // Use the provided controller
//         style: const TextStyle(
//           fontSize: 14,
//         ),
//       ),
//     );
//   }
// }

// class CustomFormInput extends StatelessWidget {
//   const CustomFormInput({
//     Key? key,
//     required String label,
//     required TextEditingController controller,
//     required FocusNode focus,
//   })  : _label = label,
//         _controller = controller,
//         _focus = focus,
//         super(key: key);

//   final String _label;
//   final TextEditingController _controller;
//   final FocusNode _focus;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 50,
//       padding: const EdgeInsets.only(left: 40),
//       decoration: ShapeDecoration(
//         shape: const StadiumBorder(),
//         color: Colors.grey[300],
//       ),
//       child: TextFormField(
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           labelText: _label,
//           contentPadding: const EdgeInsets.only(
//             top: 10,
//             bottom: 10,
//           ),
//         ),
//         focusNode: _focus,
//         controller: _controller,
//         style: const TextStyle(
//           fontSize: 14,
//         ),
//       ),
//     );
//   }
// }

class CustomFormInput extends StatelessWidget {
  const CustomFormInput({
    Key? key,
    required String label,
    required TextEditingController controller,
    required FocusNode focus,
  })  : _label = label,
        _controller = controller,
        _focus = focus,
        super(key: key);

  final String _label;
  final TextEditingController _controller;
  final FocusNode _focus;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.only(left: 40),
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        color: Colors.grey[300],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 5), // Adjust padding as needed
        child: Row(
          children: [
            Expanded(
              flex: 2, // Adjust flex as needed
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: _label,
                  contentPadding: EdgeInsets.zero, // Remove extra padding
                ),
                focusNode: _focus,
                controller: _controller,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
