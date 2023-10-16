import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gangaaramtech/Vendor/Orders/OrderDetails.dart';

class DeliveredOrdersScreen extends StatefulWidget {
  const DeliveredOrdersScreen({Key? key}) : super(key: key);

  @override
  _DeliveredOrdersScreenState createState() => _DeliveredOrdersScreenState();
}

class _DeliveredOrdersScreenState extends State<DeliveredOrdersScreen> {
  // Define a list to store delivered orders
  List<DocumentSnapshot> deliveredOrders = [];

  @override
  void initState() {
    super.initState();
    // Fetch the list of delivered orders from Firestore when the screen loads
    fetchDeliveredOrders();
  }

  void fetchDeliveredOrders() async {
    try {
      // Fetch the list of orders with 'Delivered' status
      final User? user = FirebaseAuth.instance.currentUser;
      final vendorId = user?.uid; // Use the user's UID as the vendor ID
      final ordersCollection = FirebaseFirestore.instance
          .collection('vendors')
          .doc(vendorId)
          .collection('orders');

      final snapshot = await ordersCollection
          .where('status', isEqualTo: 'Delivered')
          .get();

      setState(() {
        deliveredOrders = snapshot.docs;
      });
    } catch (error) {
      print('Error fetching delivered orders: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Delivered Orders',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: deliveredOrders.isEmpty
          ? const Center(
              child: Text('You have no delivered orders'),
            )
          : ListView.builder(
              itemCount: deliveredOrders.length,
              itemBuilder: (context, index) {
                final order = deliveredOrders[index];
                final data = order.data() as Map<String, dynamic>;
                final orderId = order.id;
                final orderStatus = data['status'];
                final addressData = data['addressData'] as Map<String, dynamic>;

                //    final medicineNames = List<String>.from(data['medicineNames']);
                final total = data['total'];

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text('Order ID: $orderId'),
                        const Spacer(),
                        Text(" Total cost: ₹$total"),
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Text('Ordered by ${addressData['fullName']}'),
                            const Spacer(),
                            Text('Phone ${addressData['mobileNumber']}')
                          ],
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Status: $orderStatus')),
                        /* const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Medicine Names",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: medicineNames.map((medicineName) {
                              return Text(medicineName);
                            }).toList(),
                          ),
                        ),*/
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to the OrderDetailsScreen and pass the orderId as a route argument
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OrderDetailsScreen(orderId: orderId),
                              ),
                            );
                          },
                          child: const Text("View Order Details"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
