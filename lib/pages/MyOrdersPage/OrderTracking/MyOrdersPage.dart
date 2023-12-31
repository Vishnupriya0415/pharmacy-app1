// ignore_for_file: file_names, prefer_const_constructors_in_immutables, recursive_getters, unused_local_variable

import 'package:flutter/material.dart';
//import 'package:gangaaramtech/pages/MyOrdersPage/CurrentOrders.dart';
//import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/CurrentOrders.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/CurrentOrdersScreen.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/RecentOrdersScreen.dart';
import 'package:gangaaramtech/pages/home/home.dart';
//import 'package:gangaaramtech/pages/search_result_page/search_result_page.dart';
//import 'RecentOrders.dart';

class MyOrdersPage extends StatelessWidget {
  MyOrdersPage({Key? key}) : super(key: key);

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
                    //     Tab(text: 'Items in Cart'),
                  ],
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.black,
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              /* SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: MyCurrentScreen(
                    myListOfOrders: currentOrders,
                  ),
                ),
              ),*/
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const CurrentOrdersScreen(),
                ),
              ),
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  //  child: MyListSecond(myListOfOrders: recentOrders),
                  child: RecentOrdersScreen(key: key),
                ),
              ),
              /* SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  //child: (),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
