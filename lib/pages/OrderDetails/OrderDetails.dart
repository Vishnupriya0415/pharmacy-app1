// ignore_for_file: prefer_const_constructors_in_immutables, avoid_unnecessary_containers, file_names

import 'package:flutter/material.dart';
import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';


class OrderedMedicine {
  final List<String> medicineName;
  final String orderId;
  final String name;
  final String medicalShopName;
  final String deliveryLocation;
  final bool deliveryState;
  final String quantity;
  final List<int> cost;
  final String deliveredDate;
  final double deliveryFee;
  final double packingCharges;
  final double taxes;
  final bool paymentStatus;

  OrderedMedicine({
    required this.medicineName,
    required this.paymentStatus,
    required this.deliveredDate,
    required this.orderId,
    required this.name,
    required this.medicalShopName,
    required this.deliveryLocation,
    required this.deliveryState,
    required this.quantity,
    required this.cost,
    required this.packingCharges,
    required this.deliveryFee,
    required this.taxes,
  });
  int get totalPrice => cost.reduce((value, element) => value + element);
}

class OrderDetailsScreen extends StatelessWidget {
  final OrderedMedicine order;

  OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Column(
              children: [
                Text(
                  ' Order ${order.orderId} ',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  " Delivered "
                      "\u20B9${(order.totalPrice + order.packingCharges
                      + order.deliveryFee +
                      order.taxes).toStringAsFixed(2)} ",
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
              ],
            ),
            const Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  " HELP",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[200],
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Image.asset(
                              "assets/images/tablets/location1.png",
                              height: 80,
                              width: 50,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  ' ${order.medicalShopName}',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 17),
                                ),
                                const Text('Tirupati'),
                                const SizedBox(height: 30),
                                const Text(
                                  "Home",
                                  style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                                ),
                                Container(
                                  child: Tooltip(
                                    message: order.deliveryLocation,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        ' ${order.deliveryLocation}',
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        // ignore: prefer_const_constructors
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(50, 8, 10, 8),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        children: [
                          order.deliveryState
                              ? Image.asset(
                            "assets/images/tablets/tick mark2.jpg",
                            height: 20,
                            width: 40,
                          )
                              : Image.asset(
                            "assets/images/tablets/order_preocessing.jpg", // Add the path to the cross mark image
                            height: 70,
                            width: 90,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                order.deliveryState
                                    ? Text(
                            ' Order delivered on ${order.deliveredDate} ',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            )
                                    : Text(
                                  ' Order  will be delivered on ${order.deliveredDate} ',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    " by  ${order.name} ",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                  ),
                                ),
                                const SizedBox(height: 10,)
                              ],
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
              const Padding(
                padding:  EdgeInsets.fromLTRB(20, 5, 2, 5),
                child:  Align(
                    alignment: Alignment.centerLeft,
                    child:  Text(" BILL DETAILS")),
              ),
               Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        for (var i = 0; i < order.medicineName.length; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Text("${order.medicineName[i]} x ${order.quantity}"),
                                const Spacer(),
                                Text("\u20B9${order.cost[i].toStringAsFixed(2)}"),
                              ],
                            ),
                          ),
                        const SizedBox(height: 2,),
                        FDottedLine(
                          color: Colors.black,
                          width: 400,
                          strokeWidth: 1.0,
                          dottedLength: 2.0,
                          space: 2.0,
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            const Text(" Item total"),
                            const Spacer(),
                            Text( '\u20B9${order.totalPrice}')
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            const Text(" Order Packing Charges"),
                            const Spacer(),
                            Text("\u20B9${order.packingCharges}")
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            const Text(" Delivery Partner Fee"),
                            const Spacer(),
                            Text("\u20B9${order.deliveryFee}")
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            const Text(" Taxes"),
                            const Spacer(),
                            Text("\u20B9${order.taxes}")
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Container(
                          height: 1, // Set the desired height of the divider
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey, // Color of the dots
                                width: 1, // Width of the dots
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            order.paymentStatus
                                ? const Text(" paid")
                                : const Text("Not paid yet"),
                            const Spacer(),
                            Text('Total Price: \u20B9${(order.totalPrice + order.packingCharges
                                + order.deliveryFee +
                                order.taxes).toStringAsFixed(2)}'),
                          ],
                        ),
                        const SizedBox(height: 5,),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

