// ignore_for_file: file_names, prefer_const_constructors_in_immutables, recursive_getters, unused_import

import 'package:flutter/material.dart';
//import 'package:gangaaramtech/pages/MyOrdersPage/CurrentOrders.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/CurrentOrders.dart';
import 'package:gangaaramtech/pages/home/home.dart';
import 'package:gangaaramtech/pages/search_result_page/search_result_page.dart';
import 'RecentOrders.dart';
import 'Items_in_cart.dart';
class MyOrdersPage extends StatelessWidget {

  MyOrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<MyListOfOrders> recentOrders = [
      MyListOfOrders(
          quantity: 2,
          medicineName: ['Cetrizeine', 'Paracetamol'],
          dosage: 'Ad directed by physician',
          tablets: 'Syrup of 60ml',
          shippingMethod: 'Standard shipping',
          Cost: [85, 29],
          pharmacyName: 'Apollo pharmacy',
          packingCharges: 4.0,
          deliveryFee: 5.0,
          taxes: 10.0,
          OrderId: 'ord1246'),
      MyListOfOrders(
        quantity: 1,
        medicineName: [
          'Paracetamol',
        ],
        dosage: '1 tablet every 4 hours',
        tablets: 'Tablets',
        shippingMethod: 'Express shipping',
        Cost: [29],
        pharmacyName: 'Apollo pharmacy',
        packingCharges: 4.0,
        deliveryFee: 5.0,
        OrderId: 'ord1923',
        taxes: 10.0,
      ),
    ];

    List<MyListOfOrders> currentOrders = [
      MyListOfOrders(
        quantity: 2,
        medicineName: ['Cetrizeine', 'Paracetamol'],
        dosage: 'Ad directed by physician',
        tablets: 'Syrup of 60ml',
        shippingMethod: 'Standard shipping',
        Cost: [85, 29],
        pharmacyName: 'Apollo pharmacy',
        packingCharges: 4.0,
        deliveryFee: 5.0,
        OrderId: 'ord1246',
        taxes: 10.0,
      ),
      MyListOfOrders(
          quantity: 1,
          medicineName: [
            'Paracetamol',
          ],
          dosage: '1 tablet every 4 hours',
          tablets: 'Tablets',
          shippingMethod: 'Express shipping',
          Cost: [29],
          pharmacyName: 'Apollo pharmacy',
          packingCharges: 4.0,
          deliveryFee: 5.0,
          taxes: 10.0,
          OrderId: 'ord1923'),
    ];
    //SelectedData selectedData = SelectedData(
    //medicineName: 'cetrizine', 
    //pharmacyData: {
    //'name': 'medplus', 
    //},
    //);
    return Scaffold(
      body: DefaultTabController(
        length: 3, // Number of tabs
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: const Text(
                  'My Orders',
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
                        builder: (context) => Home(),
                      ),
                    );
                  },
                ),
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Current Orders'),
                    Tab(text: 'Recent Orders'),
                    Tab(text: 'Items in Cart'),
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
                  child: MyCurrentScreen(
                    myListOfOrders: currentOrders,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: MyListSecond(myListOfOrders: recentOrders),
                ),
              ),
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const CartPage(

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
