// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';
import 'package:gangaaramtech/Vendor/Order_provider.dart';
import 'package:provider/provider.dart';

class OrderManagementPage extends StatefulWidget {
  @override
  _OrderManagementPageState createState() => _OrderManagementPageState();
}

class _OrderManagementPageState extends State<OrderManagementPage> {
  // Mock data for orders (you should replace this with real data)
 

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Order Management', style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (BuildContext context, int index) {
          final order = orders[index];
          return ListTile(
            title: Row(
              children: [
                Text('Order ID: ${order.id}', style: const TextStyle(color: Colors.grey),),
                const Spacer(),
                 Text('Cash on Delivery ${order.totalAmount}',style: const TextStyle(color: Colors.grey), )
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Customer: ${order.customerName}'),
                     const Spacer(),
                     Text('Status: ${order.isAccepted ? 'Accepted' : 'Pending'}'),   
                  ],
                ),
                Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: order.medicineNames.map((medicineName) {
              return Text('Medicine: $medicineName');
            }).toList(),
          ),
                const SizedBox(height: 7,),
               Row(
                 children: [
                  ElevatedButton(
              onPressed: () {
              },
                   style: ElevatedButton.styleFrom(
                    backgroundColor:  Colors.blue, // Change background color based on status
              ),
                   child: const Text(
                    'View Order details',
                    style: TextStyle(
                      color:  Colors.white,
                         )      ),
            ),
                  const Spacer(),
                   ElevatedButton(
              onPressed: () {
                    // Toggle order acceptance when the button is pressed
                    _toggleOrderAcceptance(order);
              },
                   style: ElevatedButton.styleFrom(
                    backgroundColor: order.isAccepted ? Colors.white: Colors.blue, // Change background color based on status
              ),
                   child: Text(
                    order.isAccepted ? 'Accepted' : 'Accept Order',
                    style: TextStyle(
                      color: order.isAccepted ? Colors.black : Colors.white, // Change text color based on status
                         )      ),// Toggle button text
            ),
                 ],
               ),// Toggle status text
              ],
            ),
          );
        },
      ),
    );
  }

  void _toggleOrderAcceptance(MyOrder order) {
    setState(() {
       order.isAccepted = true; // Toggle the acceptance status
    });
  }
}

class MyOrder {
  final String id;
   final List<String> medicineNames;
  final String customerName;
  final String totalAmount;
 // final String? pharmacyName;
  bool isAccepted; // Flag to track acceptance status

   MyOrder({
    required this.id,
  //  required this.pharmacyName,
    required this.medicineNames,
    required this.customerName,
    required this.totalAmount,
    required this.isAccepted,
  });
}


