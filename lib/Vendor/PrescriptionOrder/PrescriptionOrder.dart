import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gangaaramtech/Vendor/PrescriptionOrder/OrderDetails.dart';

class PrescriptionOrdersPage extends StatefulWidget {
  const PrescriptionOrdersPage({Key? key}) : super(key: key);

  @override
  _PrescriptionOrdersPageState createState() => _PrescriptionOrdersPageState();
}

class _PrescriptionOrdersPageState extends State<PrescriptionOrdersPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentUser != null
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('vendors')
                  .doc(_currentUser!.uid)
                  .collection('orders')
                  .where('status', isEqualTo: 'pending')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No pending prescription orders."),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var order = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    bool isPrescription = order['isPrescription'] ?? false;
                    String userUid = order['userUid'];
                    DocumentReference userDocRef = FirebaseFirestore.instance
                        .collection('users')
                        .doc(userUid);

                    return FutureBuilder<DocumentSnapshot>(
                      future: userDocRef.get(),
                      builder: (context, userDocSnapshot) {
                        if (userDocSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (userDocSnapshot.hasError) {
                          return Text(
                              'Error accessing user document: ${userDocSnapshot.error}');
                        }

                        if (userDocSnapshot.hasData &&
                            userDocSnapshot.data != null) {
                          Map<String, dynamic> userData = userDocSnapshot.data!
                              .data() as Map<String, dynamic>;
                          String username = userData['Name'];
                          String phone = userData['phone'];

                          if (isPrescription) {
                            String orderID = snapshot.data!.docs[index].id;
                            String imageUrl = order['imageURL'] ?? '';

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 3,
                                color: Colors.grey[150],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                margin: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => OrderDetailsPage(
                                          orderID: orderID,
                                          imageUrl: imageUrl,
                                          phone: phone,
                                          name: username,
                                        ),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    title: Column(
                                      children: [
                                        Text("Order ID: $orderID"),
                                      ],
                                    ),
                                    subtitle: Row(
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: imageUrl.isNotEmpty
                                              ? Image.network(imageUrl)
                                              : Container(
                                                  width: 100,
                                                  height: 100,
                                                  color: Colors.grey,
                                                ),
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        Column(
                                          children: [
                                            Text('Ordered by $username'),
                                            Text('Phone : $phone'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        }

                        return Container();
                      },
                    );
                  },
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
