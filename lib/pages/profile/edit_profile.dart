import 'package:flutter/material.dart';
import 'package:gangaaramtech/pages/common/onboardingscreen.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = "/profileScreen";

  const ProfileScreen({super.key});

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
                        'Hi there Roopa',
                        style: GoogleFonts.lato(
                          fontSize: 28,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const CustomFormInput(
                        label: "Name",
                        value: "Roopa",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const CustomFormInput(
                        label: "Email",
                        value: "roopa@email.com",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const CustomFormInput(
                        label: "Mobile No",
                        value: "9320245928",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const CustomFormInput(
                        label: "Address",
                        value: "2-28, Mannila, Anantapur, Andra Pradesh",
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
}

class CustomFormInput extends StatelessWidget {
  const CustomFormInput({
    Key? key,
    required String label,
    required String value,
  })  : _label = label,
        _value = value,
        super(key: key);

  final String _label;
  final String _value;

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
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: _label,
          contentPadding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
        ),
        initialValue: _value,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}

void _showSignOutAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _performSignOut(context);
            },
            child: const Text('Sign Out'),
          ),
        ],
      );
    },
  );
}

void _performSignOut(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const OnboardingScreen(),
    ),
  );
}
