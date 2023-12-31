// ignore_for_file: file_names, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/Address/EditAddressPage.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/PlacingOrderPage.dart';
//import 'package:gangaaramtech/pages/MyOrdersPage/Address/EditAdressPage.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
      ),
      body: Column(
        children: [
          const Expanded(child: AddressList()),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddressPage(
                      isEditing: false,
                    ),
                  ),
                );
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.blue), // Change the color to your preference
              ),
              child: const Text(
                "Add New Address",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddressList extends StatefulWidget {
  const AddressList({super.key});

  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  String selectedAddressId = ''; // Store the ID of the selected address

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fetchAddresses(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No addresses found.'),
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((document) {
            Map<String, dynamic> addressData =
                document.data() as Map<String, dynamic>;
            String addressId = document.id;
            // Get the address ID

            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Radio<String>(
                      value: addressId,
                      groupValue: selectedAddressId,
                      onChanged: (value) {
                        setState(() {
                          selectedAddressId = value!;
                        });
                      },
                    ),
                    title: Text(
                      ' ${addressData['fullName']}, ${addressData['mobileNumber']}, ${addressData['doorNo']}, ${addressData['street']}, ${addressData['city']}, ${addressData['postalCode']}, ${addressData['state']}',
                    ),
                  ),
                  if (selectedAddressId == addressId)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              // print(addressId);
                              Map<String, dynamic> addressData =
                                  document.data() as Map<String, dynamic>;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlacingOrder(addressData: addressData,)
                                ),
                              );
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.green),
                            ),
                            child: const Text(
                              "Use This address for delivery",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Map<String, dynamic> addressData =
                                  document.data() as Map<String, dynamic>;
                              // Handle using this address for delivery
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddressPage(
                                    isEditing: true,
                                    addressData: addressData,
                                    selectedAddressId: addressId,
                                  ),)
                              );
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.orange),
                            ),
                            child: const Text(
                              "Edit Address",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              removeAddress(addressId);
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.red),
                            ),
                            child: const Text(
                              "Remove this address",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}


Future<void> removeAddress(String addressId) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userUID = user.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userUID)
          .collection('addresses')
          .doc(addressId) // Specify the document ID to delete
          .delete();

      // If successful, you may want to update the UI or show a success message.
    } else {
      // Handle the case where the user is not authenticated.
    }
  } catch (error) {
    // Handle any errors that may occur during the deletion.
    print("Error removing address: $error");
    // You can show an error message to the user if needed.
  }
}
/*Stream<List<DocumentSnapshot>> fetchAddresses() {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    String userUID = user.uid;

    // Fetch the user's address from the 'users' collection
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
    Query userQuery = usersCollection.where('uid', isEqualTo: userUID);

    // Fetch addresses from the 'addresses' collection
    CollectionReference addressesCollection = FirebaseFirestore.instance.collection('addresses');
    Query addressesQuery = addressesCollection.where('userId', isEqualTo: userUID);

    return userQuery.get().then((userQuerySnapshot) {
      DocumentSnapshot userDocument;
      if (userQuerySnapshot.docs.isNotEmpty) {
        userDocument = userQuerySnapshot.docs.first;
      } else {
        userDocument = userQuerySnapshot.docs.first;
      }

      return addressesQuery.get().then((addressesQuerySnapshot) {
        // Combine user's address with addresses from 'addresses' collection
        List<DocumentSnapshot> addressesData = addressesQuerySnapshot.docs;
        // Add the user's address to the list if it's not empty
        if (userDocument.exists) {
          addressesData.insert(0, userDocument);
        }
        return addressesData;
      });
    }).asStream();
  } else {
    // Return an empty stream if no user is authenticated
    return Stream.value([]);
  }
}*/

/*Stream<List<DocumentSnapshot>> fetchAddresses() {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    String userUID = user.uid;

    // Fetch the user's address from the 'users' collection
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
    Query userQuery = usersCollection.where('uid', isEqualTo: userUID);

    // Fetch addresses from the 'addresses' collection
    CollectionReference addressesCollection = FirebaseFirestore.instance.collection('addresses');
    Query addressesQuery = addressesCollection.where('userId', isEqualTo: userUID);

    return userQuery.get().then((userQuerySnapshot) {
      DocumentSnapshot userDocument;
      if (userQuerySnapshot.docs.isNotEmpty) {
        userDocument = userQuerySnapshot.docs.first;
      } else {
        userDocument = userQuerySnapshot.docs.first;
      }

      return addressesQuery.get().then((addressesQuerySnapshot) {
        // Combine user's address with addresses from 'addresses' collection
        List<DocumentSnapshot> addressesData = addressesQuerySnapshot.docs;
        // Add the user's address to the list if it's not empty
        if (userDocument.exists) {
          addressesData.insert(0, userDocument);
        }
        return addressesData;
      });
    }).asStream();
  } else {
    // Return an empty stream if no user is authenticated
    return Stream.value([]);
  }
}*/


Stream<QuerySnapshot> fetchAddresses() {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    String userUID = user.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .collection('addresses')
        .snapshots();
  } else {
    // Return an empty stream if no user is authenticated
    return const Stream.empty();
  }
}
