import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MedicalDeliveryApp());
}

class MedicalDeliveryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Delivery Order Tracking',
      home: OrderTrackingPage(),
    );
  }
}

class MedicineOrder {
  String orderId;
  String patientName;
  String medicationName;
  String status;
  DateTime deliveryDate;

  MedicineOrder({
    required this.orderId,
    required this.patientName,
    required this.medicationName,
    required this.status,
    required this.deliveryDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
     // 'patientName': patientName,
      'medicationName': medicationName,
      'status': status,
      'deliveryDate': deliveryDate,
    };
  }

  factory MedicineOrder.fromMap(Map<String, dynamic> data) {
    return MedicineOrder(
      orderId: data['orderId'],
      patientName: data['patientName'],
      medicationName: data['medicationName'],
      status: data['status'],
      deliveryDate: (data['deliveryDate'] as Timestamp).toDate(),
    );
  }
}

class OrderTrackingPage extends StatefulWidget {
  @override
  _OrderTrackingPageState createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('medicine_orders');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Delivery Order Tracking'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ordersCollection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final orders = snapshot.data!.docs
              .map((doc) => MedicineOrder.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                child: ListTile(
                  title: Text('Order ID: ${order.orderId}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Patient: ${order.patientName}'),
                      Text('Medication: ${order.medicationName}'),
                      Text('Status: ${order.status}'),
                      Text('Delivery Date: ${order.deliveryDate.toString()}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add logic to create a new order
         
        },
        child: Icon(Icons.add),
      ),
    );
  }

  
}
