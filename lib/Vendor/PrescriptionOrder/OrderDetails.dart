// ignore_for_file: no_logic_in_create_state, avoid_print, library_private_types_in_public_api, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/utils/widgets/Alert_dialog_box.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderID;
  final String imageUrl;

  const OrderDetailsPage({super.key, 
    required this.orderID,
    required this.imageUrl,
  });

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState(orderID);
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final String orderID;
  double? totalPrice;
String? Name;
  String? phone;
  String? doorNO;
  String? street;
  String? city;
  String? landmark;
  String? pincode;
  String? state;
  _OrderDetailsPageState(this.orderID);

  @override
  void initState() {
    super.initState();
    fetchTotalPrice();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    String? userUID = user?.uid;

    if (userUID != null) {
      try {
        DocumentSnapshot orderSnapshot = await firestore
            .collection('vendors')
            .doc(userUID)
            .collection('orders')
            .doc(widget.orderID)
            .get();

        if (orderSnapshot.exists) {
          Map<String, dynamic> orderData =
              orderSnapshot.data() as Map<String, dynamic>;

          final name = orderData['address']['fullName'];
          final mobileNumber = orderData['address']['mobileNumber'];
          final City = orderData['address']['city'];
          final DoorNo = orderData['address']['doorNo'];
          final Landmark = orderData['address']['landmark'];
          final postalCode = orderData['address']['postalCode'];
          final Street = orderData['address']['street'];
          final State = orderData['address']['state'];
          setState(() {
            Name = name;
            phone = mobileNumber;
            city = City;
            doorNO = DoorNo;
            landmark = Landmark;
            pincode = postalCode;
            street = Street;
            state = State;
          });
        }
      } catch (e) {
        // Handle the error, for example, show an error message
        print("Error fetching data: $e");
      }
    }  

}

  Future<void> fetchTotalPrice() async {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    String? userUID = user?.uid;

    if (userUID != null) {
      try {
        DocumentSnapshot orderSnapshot = await firestore
            .collection('vendors')
            .doc(userUID)
            .collection('orders')
            .doc(widget.orderID)
            .get();

        if (orderSnapshot.exists) {
          Map<String, dynamic> orderData =
              orderSnapshot.data() as Map<String, dynamic>;

          
          if (orderData.containsKey('total')) {
            double fetchedTotal = orderData['total'];
            setState(() {
              totalPrice = fetchedTotal;
            });
          }
        }
      } catch (e) {
        // Handle the error, for example, show an error message
        print("Error fetching total price: $e");
      }
    }
  }

  Future<void> updateTotalPrice(double newTotal) async {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String? userUID = user?.uid;

    if (userUID != null) {
      try {
        // Update the total price in the vendor's collection
        DocumentReference vendorOrderReference = firestore
            .collection('vendors')
            .doc(userUID)
            .collection('orders')
            .doc(orderID);

        await vendorOrderReference.update({'total': newTotal});

        vendorOrderReference.get().then((documentSnapshot) async {
          if (documentSnapshot.exists) {
            Map<String, dynamic> data = documentSnapshot.data()
                as Map<String, dynamic>; // Explicit casting
            String userUid = data['userUid'];
            print('userUid: $userUid');

             DocumentReference userOrderReference = firestore
            .collection('users')
            .doc(userUid)
            .collection('orders')
            .doc(widget.orderID);

        await userOrderReference.update({'total': newTotal});

          } else {
            print('Document with orderID not found');
          }
        }).catchError((error) {
          print('Error getting document: $error');
        });

        // Update the total price in the user's collection
       

        setState(() {
          totalPrice = newTotal;
        });
      } catch (e) {
        // Handle the error, e.g., show an error message
        print("Error updating total price: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Set the color of the text to blue
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ), // Use appropriate icon for back arrow
          onPressed: () {
            Navigator.pop(
                context); // Go back to the previous screen on arrow button press
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 400,
              child: PhotoView(
                imageProvider: NetworkImage(widget.imageUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                backgroundDecoration: const BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text("Order ID: ${widget.orderID}"),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text("Customer Name: $Name"),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text("Phone: $phone"),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.home, color: Colors.black),
                // Add a home icon here
                SizedBox(
                  width: 5,
                ),
                Text(" Delivery address:"),
              ],
            ),
            Text(
                " $Name, $phone , $doorNO, $landmark, $street, $state, $pincode "),
            const SizedBox(
              height: 10,
            ),
            if (totalPrice != null)
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child:
                        Text("Total Price: ₹${totalPrice!.toStringAsFixed(2)}"),
                  )),
            if (totalPrice == null)
              TextButton(
                onPressed: () {
                  // Show an alert dialog with an input field for the total price
                  TextEditingController priceController =
                      TextEditingController();
      
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CurvedAlertDialogBox(
                        title: "Enter the total price for medicines",
                        hintText: 'Please enter the total price ',
                        textController: priceController,
                        onClosePressed: () {
                          Navigator.of(context).pop();
                        },
                        keyboardType: TextInputType.number,
                        onSubmitPressed: () {
                          Navigator.of(context).pop();
                          double enteredPrice =
                              double.tryParse(priceController.text) ?? 0.0;
                          updateTotalPrice(enteredPrice);
                          Navigator.of(context).pop(); // Close the dialog
                          // Update the order status with the cancellation reason
                          // updateOrderStatus(orderId, 'Cancelled', cancellationReason);
                        },
                      );
                    },
                  );
                },
                child: const Text("Add Cost"),
              ),
          ],
        ),
      ),
    );
  }
}
