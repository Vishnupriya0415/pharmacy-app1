// ignore: file_names
// ignore_for_file: file_names, non_constant_identifier_names, duplicate_ignore

//import 'Address/AddressPage.dart';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/Address/AddressPage.dart';
import 'package:gangaaramtech/pages/OrderDetails/OrderDetails.dart';
class MyListOfOrders {
  final List<String> medicineName;
  final String dosage;
  final String tablets;
  final String shippingMethod;
  final String OrderId;
  final List<int> Cost;
  int quantity;
  final String pharmacyName;
  final int noOfMedicines;
  final double deliveryFee;
  final double packingCharges;
  final double taxes;

  MyListOfOrders({
    required this.quantity,
    required this.medicineName,
    required this.dosage,
    required this.tablets,
    required this.OrderId,
    required this.shippingMethod,
    required this.Cost,
    required this.pharmacyName,
    required this.packingCharges,
    required this.taxes,
    required this.deliveryFee,
  }): noOfMedicines = medicineName.length;
  int get totalPrice => Cost.reduce((value, element) => value + element);

}

// ignore: must_be_immutable
class MyListSecond extends StatefulWidget {
  final List<MyListOfOrders> myListOfOrders;
  MyListSecond({super.key, required this.myListOfOrders});

  List<OrderedMedicine> order=[
  OrderedMedicine(
  deliveryLocation: '20-2-262/A, Koraguntla,Tirupati, Andra Pradesh',
  medicineName: ['Cetrizeine','Paracetamol',], // Replace with actual data
  orderId: 'ORD18790', // Replace with actual data
  cost: [85, 29],
  deliveryState: true,
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
      deliveryState: true,
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
  State<MyListSecond> createState() => _MyListSecondState();
}

class _MyListSecondState extends State<MyListSecond> {
  @override
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
                      Row(
                        children: [
                          Text('Total items: ${myListOfOrder.noOfMedicines}',),
                          const Spacer(),
                          Row(
                            children: [
                              const Text(" Delivered"),
                              Image.asset("assets/images/tablets/mark.jpg", height: 20, width: 40,)
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Total Price: \u20B9${myListOfOrder.totalPrice + myListOfOrder.packingCharges
                              +myListOfOrder.taxes+ myListOfOrder.deliveryFee}'),
                          const Spacer(),
                          const Text("Date: 12-08-2023"),
                        ],
                      ),
                      Text(" Pharmacy Name: ${myListOfOrder.pharmacyName}"),
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
                                  builder: (context) => OrderDetailsScreen(order: widget.order[myListOfOrderIndex]),
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
                                child: Text("View order details", style: TextStyle(fontSize: 16 ,
                                    color: Colors.white)),
                              ),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddressScreen(),
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
                                child: Text("Reorder", style: TextStyle(fontSize: 16 , color: Colors.white)),
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
