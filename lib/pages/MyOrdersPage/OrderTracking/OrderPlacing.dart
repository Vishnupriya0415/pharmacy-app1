// ignore_for_file: file_names, use_key_in_widget_constructors, non_constant_identifier_names, library_private_types_in_public_api, prefer_const_constructors, sized_box_for_whitespace

import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';

class OrderSummary {
  final List<OrderItem> items;
  final double deliveryCharge;
  final double taxes;
  final String deliveryAddress;
  OrderSummary({
    required this.items,
    required this.deliveryCharge,
    required this.taxes,
    required this.deliveryAddress,
  });
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

class OrderPlacingPage extends StatefulWidget {
  final OrderSummary orderSummary;

  const OrderPlacingPage({
    required this.orderSummary,
  });
  @override
  _OrderPlacingPageState createState() => _OrderPlacingPageState();
}

class _OrderPlacingPageState extends State<OrderPlacingPage> {
  @override
  Widget build(BuildContext context) {
    final List<String> imagePaths = [
      'assets/images/tablets/creditcard_icon.png',
      'assets/images/tablets/phonepe_icon.webp',
      'assets/images/tablets/paytm_icon.png',
      'assets/images/tablets/googlePay.png',
      'assets/images/tablets/cash_on_delivery.jpg',
    ];
    final List<String> PaymentMethods = [
      ' Debit/ credit card',
      ' Phone Pe',
      'Paytm',
      'Google Pay',
      'Cash on Delivery '
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    " Order details",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  )),
              const SizedBox(
                height: 5,
              ),
              Card(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          " Medicine Details: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Spacer(),
                        Text(
                          " Qty:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          " Cost ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        for (OrderItem item in widget.orderSummary.items)
                          Row(
                            children: [
                              Text('${item.name} '),
                              const Spacer(),
                              Text("${item.quantity}"),
                              const SizedBox(
                                width: 23,
                              ),
                              Text("${item.price}"),
                              const SizedBox(
                                width: 5,
                              )
                            ],
                          ),
                        const SizedBox(
                          height: 5,
                        ),
                        FDottedLine(
                          color: Colors.black,
                          width: 400,
                          strokeWidth: 1.0,
                          dottedLength: 2.0,
                          space: 2.0,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Delivery Charges: ",
                              style: TextStyle(fontSize: 14),
                            ),
                            const Spacer(),
                            Text('₹${widget.orderSummary.deliveryCharge}'),
                            const SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Taxes ",
                              style: TextStyle(fontSize: 14),
                            ),
                            const Spacer(),
                            Text('₹${widget.orderSummary.taxes}'),
                            const SizedBox(
                              width: 5,
                            )
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Total Cost: ₹${calculateTotalCost(widget.orderSummary).toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: Card(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Delivery  Address:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                              onTap: () {},
                              child: const Text(
                                " change ",
                                style: TextStyle(color: Colors.blue),
                              )),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.orderSummary.deliveryAddress,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select a Payment Method :',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: imagePaths.length,
                itemBuilder: (context, index) {
                  final imagePath = imagePaths[index];
                  final paymentMethod = PaymentMethods[index];

                  return ListTile(
                    leading: Image.asset(
                      imagePath,
                      width: 30, // Set an appropriate width for your image
                      height: 30, // Set an appropriate height for your image
                    ),
                    title: Text(paymentMethod),
                    onTap: () {
                      // Handle payment method selection here
                    },
                  );
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.blue),
                  ),
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: const Text(
                  'Place Order',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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

double calculateTotalCost(OrderSummary orderSummary) {
  double totalCost = 0.0;

  // Calculate the total cost of items
  for (OrderItem item in orderSummary.items) {
    totalCost += (item.price * item.quantity);
  }

  // Add delivery charges and taxes
  totalCost += orderSummary.deliveryCharge + orderSummary.taxes;

  return totalCost;
}
