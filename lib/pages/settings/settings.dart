// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
//import 'package:gangaaramtech/Vendor/VendorInforScreens/VendorInfo1.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/MyOrdersPage.dart';
import 'package:gangaaramtech/pages/common/onboardingscreen.dart';
import 'package:gangaaramtech/pages/profile/edit_profile.dart';
import 'package:gangaaramtech/pages/settings/AboutPage.dart';
import 'package:gangaaramtech/pages/settings/edit_settings.dart';
import 'package:gangaaramtech/repository/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gangaaramtech/repository/firestorefunctions.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map<String, dynamic> userData = {};
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    Map<String, dynamic> data = await FireStoreFunctions().getUserData();
    setState(() {
      userData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: Colors.black, // Menu icon on the left side
          onPressed: () {
            // Add your menu functionality here
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.black, // Notifications icon on the right side
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        // Add height to the Container to ensure it's visible
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            const SizedBox(
              height: 70,
            ),
            // Profile Icon Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ClipOval(
                    child: Container(
                      width: 100,
                      height: 100,
                      child: userData['profileImageUrl'] != null
                          ? Image.network(
                              userData['profileImageUrl'],
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              "assets/images/tablets/profileIcon.png",
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(" ${userData['Name']}"),
                  Text("${userData['phone']}"),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),

            // Edit Profile Option
            Card(
              // Add Card to wrap the Container
              elevation: 0, // Remove the shadow
              child: Container(
                padding: const EdgeInsets.all(8), // Add padding
                child: Column(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Center the Column content vertically
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Center the content horizontally
                  children: [
                    ListTile(
                      title: const Column(
                        // Use a Column to display the title text below the icon
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center the text vertically
                        children: [
                          Center(
                            // Center the icon
                            child: Icon(Icons.person),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Edit',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            ' Profile',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                    userData: userData,
                                  )),
                        );
                        // Add your edit profile functionality here
                      },
                    ),
                  ],
                ),
              ),
            ),

            // My Orders Option
            Card(
              // Add Card to wrap the Container
              elevation: 0, // Remove the shadow
              child: Container(
                padding: const EdgeInsets.fromLTRB(35, 5, 40, 2),
                child: ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text('My Orders'),
                  trailing: const Text(
                    // Display greater than symbol as trailing widget
                    '>',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                     Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyOrdersPage(), // Replace with your MyOrdersPage widget
          ),
        );
                  },
                ),
              ),
            ),

            // Payment Methods Option
            Card(
              // Add Card to wrap the Container
              elevation: 0, // Remove the shadow
              child: Container(
                padding: const EdgeInsets.fromLTRB(35, 5, 40, 2),
                child: ListTile(
                  leading: const Icon(Icons.payment),
                  title: const Text('Payment'),
                  trailing: const Text(
                    // Display greater than symbol as trailing widget
                    '>',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    // Add your functionality here
                  },
                ),
              ),
            ),

            // Settings Option
            Card(
              // Add Card to wrap the Container
              elevation: 0, // Remove the shadow
              child: Container(
                padding: const EdgeInsets.fromLTRB(35, 5, 40, 2), // Add padding
                child: ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  trailing: const Text(
                    // Display greater than symbol as trailing widget
                    '>',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditSettingsPage()),
                    );
                  },
                ),
              ),
            ),
            Card(
              // Add Card to wrap the Container
              elevation: 0, // Remove the shadow
              child: Container(
                padding: const EdgeInsets.fromLTRB(35, 5, 40, 2), // Add padding
                child: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About'),
                  trailing: const Text(
                    // Display greater than symbol as trailing widget
                    '>',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutPage()),
                    );
                  },
                ),
              ),
            ),

            // Sign Out Option
            Card(
              // Add Card to wrap the Container
              elevation: 0, // Remove the shadow
              child: Container(
                padding: const EdgeInsets.fromLTRB(35, 5, 40, 2),
                // Add padding
                child: ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Sign Out'),
                  onTap: () {
                    _showSignOutAlertDialog(context);
                    // Add your sign-out functionality here
                  },
                ),
              ),
            ),

             
          ],
        ),
      ),
    );
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
                // Perform the sign-out action here...
                // For example, you can call a sign-out function from your authentication service.
                // After successful sign-out, navigate to the main page.
                // Here, we are using pushReplacement to replace the current route with the main page.
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
    Auth().signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingScreen(),
      ),
    );
  }
}
