import 'package:flutter/material.dart';
import 'package:gangaaramtech/Vendor/OrderManagement.dart';
import 'package:gangaaramtech/Vendor/PrescriptionOrder/PrescriptionOrder.dart';
import 'package:gangaaramtech/Vendor/VHome/VendorHome.dart';
//import 'package:gangaaramtech/pages/MyOrdersPage/CurrentOrders.dart';

//import 'RecentOrders.dart';

class IncomingOrdersPage extends StatelessWidget {
  IncomingOrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //SelectedData selectedData = SelectedData(
    //medicineName: 'cetrizine',
    //pharmacyData: {
    //'name': 'medplus',
    //},
    //);
    return Scaffold(
      body: DefaultTabController(
        length: 2, // Number of tabs
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: const Text(
                  'Incoming Orders',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VendorHome(),
                      ),
                    );
                  },
                ),
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Medicine Orders'),
                    Tab(text: 'Prescription Orders'),
                    // Tab(text: 'Items in Cart'),
                  ],
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.black,
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const VendorOrdersScreen(),
                ),
              ),
              SingleChildScrollView(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      //  child: MyListSecond(myListOfOrders: recentOrders),
                      child: const PrescriptionOrdersPage())),
            ],
          ),
        ),
      ),
    );
  }
}
