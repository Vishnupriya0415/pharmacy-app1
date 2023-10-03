// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/pages/common/onboardingscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class VEditProgilePage extends StatefulWidget {
  final Map<String,dynamic> vendorData;
  const VEditProgilePage({super.key, required this.vendorData});

  @override
  State<VEditProgilePage> createState() => _EditProgilePageState();
}

class _EditProgilePageState extends State<VEditProgilePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  Map<String, dynamic> vendorData = {};
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  File? _imageFile;

  late ValueNotifier<String> nameNotifier;
  late ValueNotifier<String> addressNotifier;

  Future<void> _pickImageFromSource(ImageSource source) async {
    String uid = auth.currentUser!.uid;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Upload the new image to Firebase Storage
      await uploadImageToFirebaseStorage(_imageFile!, uid);

      // Get the download URL of the newly uploaded image
      final newImageUrl = await FirebaseStorage.instance
          .ref()
          .child('vendor_images')
          .child(uid)
          .getDownloadURL();

      // Update the user's profile image URL in Firestore
      await FirebaseFirestore.instance
          .collection('vendors')
          .doc(uid)
          .update({'profileImageUrl': newImageUrl});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile image updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> fetchVendorData() async {
    try {
      final User? currentUser = auth.currentUser;

      if (currentUser != null) {
        final String uid = currentUser.uid;
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
            await firestore.collection('vendors').doc(uid).get();

        if (snapshot.exists) {
          setState(() {
            vendorData = snapshot.data() ?? {};
          });
        }
      }
    } catch (e) {
      // Handle errors
      print('Error fetching user data: $e');
    }
  }

  Future<void> _showImagePickerDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromSource(ImageSource.gallery);
                  },
                ),
                const Padding(padding: EdgeInsets.all(16.0)),
                GestureDetector(
                  child: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromSource(ImageSource.camera);
                  },
                ),
                const Padding(padding: EdgeInsets.all(16.0)),
                GestureDetector(
                  child: const Text('Remove'),
                  onTap: () {
                    Navigator.pop(context);
                    _removeProfilePhoto();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _removeProfilePhoto() async {
    try {
      final String userId = vendorData['uid'];
      final String profileImageUrl = vendorData['profileImageUrl'];

      // Check if profileImageUrl is not null before proceeding
      if (profileImageUrl != null) {
        final storageRef =
            FirebaseStorage.instance.refFromURL(profileImageUrl);
        await storageRef.delete();

        // Update the user's profile data in Firestore by setting profileImageUrl to null
        await FirebaseFirestore.instance
            .collection('vendors')
            .doc(userId)
            .update({
          'profileImageUrl': null,
        });

        // Set the local image file to null to display the default profile image
        setState(() {
          _imageFile = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile photo removed successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Handle the case where profileImageUrl is null
        print('Profile image URL is null');
      }
    } catch (e) {
      // Handle errors
      print('Error removing profile photo: $e');
    }
  }

  void updateUserProfile() async {
    try {
      final String userId = vendorData['uid'];
      final updatedName = nameNotifier.value;

      // Update the data in Firestore using Firebase
      await FirebaseFirestore.instance.collection('vendors').doc(userId).update({
        'Name': updatedName,
      });

      print('Name Data updated successfully');
    } catch (e) {
      // Handle errors
      print('Error updating data: $e');
    }
  }

  Future<void> uploadImageToFirebaseStorage(
      File imageFile, String userId) async {
    final storageReference =
        FirebaseStorage.instance.ref().child('vendor_images').child(userId);

    try {
      // Upload the file to Firebase Storage
      await storageReference.putFile(imageFile);

      // Get the download URL of the uploaded image
      final imageUrl = await storageReference.getDownloadURL();

      // Save the URL reference to Firestore
      await FirebaseFirestore.instance
          .collection('vendors')
          .doc(userId)
          .update({'profileImageUrl': imageUrl});
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void _showSignOutAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _performSignOut(context);
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  void _performSignOut(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchVendorData();
    nameNotifier = ValueNotifier<String>(vendorData['Name'] ?? '');
  }

  void updateName(String newName) async {
    try {
      final String userId = vendorData['uid'];

      // Update the data in Firestore using Firebase
      await FirebaseFirestore.instance.collection('vendors').doc(userId).update({
        'Name': newName,
      });

      nameNotifier.value = newName; // Update the local name value

      print('Name updated successfully');
    } catch (e) {
      // Handle errors
      print('Error updating name: $e');
    }
  }

  
  @override
  Widget build(BuildContext context) {
     final String name = nameNotifier.value;
     final String email = widget.vendorData['email']??'';
    final String mobileNo = widget.vendorData['phone'] ?? '';
    final String pharmacyName = widget.vendorData['pharmacyName'] ?? '';
    final String street = widget.vendorData['address']['street']??'';
    final String dNo= widget.vendorData['address']['doorNo']??'';
     final String state= widget.vendorData['address']['state']??'';
      final String pinCode= widget.vendorData['address']['postalCode']??'';
       final String city= widget.vendorData['address']['city']??'';
final String addressText = '$dNo, $street,$city, $state, $pinCode';
        return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [],
      ),
 body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 70,
              ),
              ClipOval(
                child: Stack(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: (_imageFile != null)
                          ? Image.file(_imageFile!, fit: BoxFit.cover)
                          : (vendorData['profileImageUrl'] != null)
                              ? Image.network(
                                  vendorData['profileImageUrl'],
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "assets/images/user.png",
                                  fit: BoxFit.cover,
                                ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: GestureDetector(
                        onTap: _showImagePickerDialog,
                        child: Container(
                          height: 20,
                          width: 80,
                          color: Colors.black.withOpacity(0.2),
                          child: Image.asset(
                            "assets/images/camera.png",
                            height: 20,
                            width: 80,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Hi there $name',
                style: GoogleFonts.lato(
                  fontSize: 28,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  color: Colors.grey[200],
                  child: ListTile(
                    title: const Text('Name'),
                    subtitle: EditableNameField(
                      initialValue: name,
                      onUpdate: updateName,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  color: Colors.grey[200],
                  child: ListTile(
                    title: const Text('Mobile No'),
                    subtitle: Text(mobileNo),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  color: Colors.grey[200],
                  child: ListTile(
                    title: const Text('Email'),
                    subtitle: Text(email), // Replace with the actual email
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  color: Colors.grey[200],
                  child: ListTile(
                    title: const Text('Address'),
                    subtitle: Text(addressText),
                  ),
                ),
              ),
               const SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  color: Colors.grey[200],
                  child: ListTile(
                    title: const Text('Pharmacy name'),
                    subtitle: Text(pharmacyName),
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: updateUserProfile,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: const BorderSide(color: Colors.blue),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text("Save",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Colors.blue)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showSignOutAlertDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: const BorderSide(color: Colors.white),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text("Sign Out",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),

    ));
  }
}
class EditableNameField extends StatefulWidget {
  final String initialValue;
  final Function(String) onUpdate;

  const EditableNameField({
    Key? key,
    required this.initialValue,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _EditableNameFieldState createState() => _EditableNameFieldState();
}

class _EditableNameFieldState extends State<EditableNameField> {
  late TextEditingController _textController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _updateName() {
    widget.onUpdate(_textController.text);
    _toggleEdit();
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _textController,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _updateName,
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: Text(widget.initialValue),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _toggleEdit,
          ),
        ],
      );
    }
  }
}
