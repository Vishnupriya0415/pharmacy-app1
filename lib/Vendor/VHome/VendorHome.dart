// ignore_for_file: file_names, non_constant_identifier_names
//import 'package:application1/Vendor/VendorInfo/VendorInfo2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/Vendor/OrderManagement.dart';
import 'package:gangaaramtech/Vendor/common/Settings.dart';
import 'package:gangaaramtech/repository/firestorefunctions.dart';
import 'package:gangaaramtech/utils/constants/font_constants.dart';

class VendorHome extends StatefulWidget {
  const VendorHome({super.key});

  @override
  State<VendorHome> createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
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

  @override
  Widget build(BuildContext context) {
     int currentIndex = 0;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(right: 1),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: BottomNavigationBar(backgroundColor: Colors.transparent,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            type: BottomNavigationBarType .fixed,
            onTap: (index) {
              if (index == currentIndex) {
                return;
              }
              setState(() {
                currentIndex = index;
              });
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VendorHome(),
                  ),
                );
              
              } else if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return  const VSettingsPage();
                    },
                  ),
                );
              } 
              
            }, items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
               activeIcon: Icon(Icons.home),
                   label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                ),
                label: '',
              ),
              ],),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 236, 194, 131),
              ),
            ),

            const SizedBox(height: 20,),
           
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VendorOrdersScreen(),
                  ),
                );
              },
  
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(
                      255, 133, 143, 232), // Set the background color here
                ),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          " View incoming orders",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: FontConstants.lightVioletMixedWhite,
                        ))
                  ],
                ),
  
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PendingOrdersScreen(),
                    ),
                  );*/
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(
                        255, 133, 143, 232), // Set the background color here
                  ),
                  child: const Align(
                      alignment: Alignment.center,
                      child: Text(" Update order status",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontSize: 20))),
                ),
              ),
            )

          ],
        ),
      ),
    ));
  }
}