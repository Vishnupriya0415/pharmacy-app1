
// ignore_for_file: must_be_immutable, override_on_non_overriding_member, use_key_in_widget_constructors, annotate_overrides, file_names

import 'package:flutter/material.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/OrderTracking.dart';
import 'package:gangaaramtech/pages/OrderDetails/OrderDetails.dart';
import 'RecentOrders.dart';

class MyCurrentScreen extends StatefulWidget {
  final List<MyListOfOrders> myListOfOrders;
  MyCurrentScreen({required this.myListOfOrders});

  List<OrderedMedicine> order=[
    OrderedMedicine(
      deliveryLocation: '20-2-262/A, Koraguntla,Tirupati, Andra Pradesh',
      medicineName: ['Cetrizeine','Paracetamol',], // Replace with actual data
      orderId: 'ORD18790', // Replace with actual data
      cost: [85, 29],
      deliveryState: false,
      quantity: "1",
      medicalShopName: 'Apollo pharmacy', name: 'THARUN',
      deliveredDate: '07-08-2023',
      deliveryFee: 5.0,
      packingCharges: 4.0,
      taxes: 10.0,
      paymentStatus: true,
    ),
    OrderedMedicine(
      deliveryLocation: '20-2-262/A, Koraguntla,Tirupati, Andra Pradesh',
      medicineName: ['Paracetamol',], // Replace with actual data
      orderId: 'ORD18799', // Replace with actual data
      cost: [29],
      deliveryState: false,
      quantity: "1",
      medicalShopName: 'Apollo pharmacy', name: 'HARSHA',
      deliveredDate: '07-08-2023',
      deliveryFee: 5.0,
      packingCharges: 4.0,
      taxes: 10.0,
      paymentStatus: true,
    )
  ];


  @override
  State<MyCurrentScreen> createState() => _MyCurrentScreenState();
}

class _MyCurrentScreenState extends State<MyCurrentScreen> {
  @override
  List<OrderTracker> orderTrackers = [
    const OrderTracker(status: Status.outOfDelivery, medicineNames:  ['Cetrizeine','Paracetamol',],
      medicineData: {1: 'Cetrizene#1',
        2: 'Paracetemol#2', },deliveryCharges: 5, medicinePrices: [85,29],orderPackingCharges: 4,
    deliveryAddress: '20-2-262/A, Koraguntla,Tirupati, Andra Pradesh', taxes: 10, quantity: [2,1],),

    const OrderTracker(status: Status.shipped,medicineNames: ['Paracetamol'],
    medicineData: {
      1: 'Paracatamol'}, deliveryCharges: 5,medicinePrices: [29],orderPackingCharges: 4,
    deliveryAddress: '20-2-262/A, Koraguntla,Tirupati, Andra Pradesh',taxes: 10, quantity: [2,],),
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: widget.myListOfOrders.length,
          itemBuilder: (context, myListOfOrderIndex) {
            MyListOfOrders myListOfOrder = widget.myListOfOrders[myListOfOrderIndex];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),
                  side:const  BorderSide(color: Colors.white, width: 2), ),
                elevation: 5,
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 5,),
                      Text(" ORDER ID: ${myListOfOrder. OrderId}", style:
                        const TextStyle(fontWeight: FontWeight.bold),),
                      Row(
                        children: [
                          Text('Total items: ${myListOfOrder.noOfMedicines}',),
                          const Spacer(),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Total Price: \u20B9${myListOfOrder.totalPrice + myListOfOrder.packingCharges
                              +myListOfOrder.taxes+ myListOfOrder.deliveryFee}'),
                          const Spacer(),
                          const Text("Date: 28-08-2023"),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      const Divider( thickness: 1, color: Colors.black,),
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          const Spacer(),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDetailsScreen(order:
                                  widget.order[myListOfOrderIndex]),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color:  Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("View order details", style: TextStyle(fontSize: 16 , color: Colors.white)),
                              ) ,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => orderTrackers[myListOfOrderIndex], // Access the correct OrderTracker from the list
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Track Order", style: TextStyle(fontSize: 16 , color: Colors.white)),
                              ),
                            ),
                          ),
                          const Spacer(),

                        ],
                      ),
                      const SizedBox(height: 5,),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

