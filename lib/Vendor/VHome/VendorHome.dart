// ignore_for_file: file_names, non_constant_identifier_names
//import 'package:application1/Vendor/VendorInfo/VendorInfo2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/Vendor/OrderManagement.dart';
import 'package:gangaaramtech/Vendor/VHome/CancelledOrders.dart';
import 'package:gangaaramtech/Vendor/VHome/DeliveredOrders.dart';
import 'package:gangaaramtech/Vendor/VHome/PendingOrders.dart';
import 'package:gangaaramtech/Vendor/common/Settings.dart';
import 'package:gangaaramtech/repository/firestorefunctions.dart';

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
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
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
                    return const VSettingsPage();
                  },
                ),
              );
            }
          },
          items: const [
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
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
          
            Container(
              margin: const EdgeInsets.only(
                  left: 10, top: 10, right: 10, bottom: 10),
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.orange[200],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
              child: const Text(
                " Hello",
                style: TextStyle(
                    //color: Colors.white,
                    fontSize: 25),
              ),
            ),
          
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VendorOrdersScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.green[200],
                    // Set the background color here
                  ),
                  child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        " View incoming orders",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 25),
                        //  style: FontConstants.lightVioletMixedWhite,
                      )),
                ),
              ),
            ),
            /* Padding(
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
            ),*/
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PendingDeliveriesScreen(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    // Set the background color here
                    color: Colors.purple[200],
                  ),
                  child: const Align(
                      alignment: Alignment.center,
                      child: Text(" Pending orders",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              //  color: Colors.white,
                              fontSize: 25))),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeliveredOrdersScreen(),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(
                    left: 10, top: 10, right: 10, bottom: 10),
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[200],
                  //color: Colors.orange[200],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                child: const Align(
                    alignment: Alignment.center,
                    child: Text(" Delivered  orders",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            //  color: Colors.white,
                            fontSize: 25))),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CancelledOrdersScreen(),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(
                    left: 10, top: 10, right: 10, bottom: 10),
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.yellow[200],
                  //color: Colors.orange[200],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                child: const Align(
                    alignment: Alignment.center,
                    child: Text(" Cancelled  orders",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            //  color: Colors.white,
                            fontSize: 25))),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
