// ignore_for_file: file_names, sized_box_for_whitespace, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/Vendor/common/VEditProfile.dart';
import 'package:gangaaramtech/pages/common/onboardingscreen.dart';
import 'package:gangaaramtech/pages/settings/AboutPage.dart';
import 'package:gangaaramtech/pages/settings/edit_settings.dart';
import 'package:gangaaramtech/repository/auth.dart';
import 'package:gangaaramtech/repository/firestorefunctions.dart';

class VSettingsPage extends StatefulWidget {
  const VSettingsPage({super.key});

  @override
  State<VSettingsPage> createState() => _VSettingsPageState();
}

class _VSettingsPageState extends State<VSettingsPage> {
   FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map<String, dynamic> VendorData = {};
  @override
  void initState() {
    super.initState();
    fetchVendorData();
  }

  Future<void> fetchVendorData() async {
    Map<String, dynamic> data = await FireStoreFunctions().getVendorData();
    setState(() {
      VendorData = data;
    });
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
             Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ClipOval(
                    child: Container(
                      width: 100,
                      height: 100,
                      child: VendorData['profileImageUrl'] != null
                          ? Image.network(
                              VendorData['profileImageUrl'],
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
                  Text(" ${VendorData['Name']}"),
                  Text("${VendorData['phone']}"),
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
      builder: (context) => VEditProgilePage(vendorData: VendorData,),
    ),
  );
},

                    ),
                  ],
                ),
              ),
            ),
             Card(
              // Add Card to wrap the Container
              elevation: 0, // Remove the shadow
              child: Container(
                padding: const EdgeInsets.fromLTRB(35, 5, 40, 2),
                child: ListTile(
                  leading: const Icon(Icons.payment),
                  title: const Text('Payment'),
                  trailing: const Text(
                    '>',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                   

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
              elevation: 0, 
              child: Container(
                padding: const EdgeInsets.fromLTRB(35, 5, 40, 2), 
                child: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About'),
                  trailing: const Text(
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
}