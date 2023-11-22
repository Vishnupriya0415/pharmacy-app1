// ignore_for_file: file_names, use_build_context_synchronously, unused_field, avoid_print

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/Vendor/VHome/VendorHome.dart';
import 'package:gangaaramtech/Vendor/VendorInforScreens/VendorInfo1.dart';
import 'package:gangaaramtech/repository/firestorefunctions.dart';
import 'package:gangaaramtech/utils/constants/color_constants.dart';
import 'package:gangaaramtech/utils/constants/font_constants.dart';
import 'package:gangaaramtech/utils/widgets/app_textfield.dart';
import 'package:gangaaramtech/utils/widgets/custom_elevated_button.dart';
import 'package:image_picker/image_picker.dart';


class VendorInfoScreen extends StatefulWidget {
  final String? email;
  const VendorInfoScreen({super.key,  required this.email});

  @override
  State<VendorInfoScreen> createState() => _VendorInfoScreenState();
}


class _VendorInfoScreenState extends State<VendorInfoScreen> {
  String selectedState = 'Andhra Pradesh'; 
    final _pharmacyNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _dNoController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _nameController = TextEditingController();
 // final _emailController =TextEditingController();

final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4= FocusNode();
  final FocusNode _focusNode5= FocusNode();
  final FocusNode _focusNode6= FocusNode();
  final FocusNode _focusNode7= FocusNode();
  final FocusNode _focusNode8 = FocusNode();
  
  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _focusNode5.dispose();
    _focusNode6.dispose();
    _focusNode7.dispose();
    _focusNode8.dispose();
  _phoneNumberController.dispose();
    _pharmacyNameController.dispose();
    _streetController.dispose();
    _dNoController.dispose();
    _pinCodeController.dispose();
    _cityController.dispose();
    _nameController.dispose(); 
    super.dispose();
  }

  void _loseFocus() {
    _focusNode1.unfocus();
    _focusNode2.unfocus();
    _focusNode3.unfocus();
    _focusNode4.unfocus();
    _focusNode5.unfocus();
    _focusNode6.unfocus();
    _focusNode7.unfocus();
    _focusNode8.unfocus();
  }
  
  File? _profileImage;

  Future<void> _pickProfilePicture() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      // Create a Firebase Storage reference with a unique filename
      String imageName =
          'vendor_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageReference =
          FirebaseStorage.instance.ref().child(imageName);

      // Upload the image file to Firebase Storage
      UploadTask uploadTask = storageReference.putFile(imageFile);

      // Get the download URL for the uploaded image
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (error) {
      print("Error uploading profile image: $error");
      return null;
    }
  }

void updateVendorsData() async {
   String email = widget.email ?? ""; // Assign an empty string if email is null

    // final firebaseAuth = FirebaseAuth.instance;
    if (_profileImage != null) {}
    String? imageUrl = await uploadProfileImage(_profileImage!);
    String res = await FireStoreFunctions().updateVendorsData(
      
      name: _nameController.text,
      email:email,
      phone: _phoneNumberController.text,
       pharmacyName: _pharmacyNameController.text, 
       doorNo: _dNoController.text,
       street: _streetController.text,
       postalCode: _pinCodeController.text,
       state: selectedState,
        city: _cityController.text,
        profileImageUrl: imageUrl

    );
    if (res == 'success') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const VendorHome(),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            res,
            style: FontConstants.blueNormal14,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

/*void updateVendorsData() async {
  String email = widget.email ?? ""; // Assign an empty string if email is null

    // final firebaseAuth = FirebaseAuth.instance;
    String res = await FireStoreFunctions().updateVendorsData(

      email: email,
      name: _nameController.text,
      phone: _phoneNumberController.text,
       pharmacyName: _pharmacyNameController.text, 
       doorNo: _dNoController.text,
       street: _streetController.text,
       postalCode: _pinCodeController.text,
       state: selectedState,
       city: _cityController.text
    );
    if (res == 'success') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const VendorHome(),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            res,
            style: FontConstants.blueNormal14,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SafeArea(child: Column(
          children: [
            Padding(
                  padding: const EdgeInsets.only(left: 8, top: 30, bottom: 30),
                  child: Text(
                    "Create your account",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  style: FontConstants.lightVioletNormal24,
                  ),
                ),

                _profileImage != null
                  ? CircleAvatar(
                      radius: 50, // Adjust the radius as needed
                      backgroundImage: FileImage(
                          _profileImage!), // Display the selected image
                    )
                  : IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: _pickProfilePicture,
                    ),
                AppTextField(
                  title: 'First Name',
                  onChanged: (a) {
                    _nameController.text = a;
                  },
                  onEditingComplete: _loseFocus,
                  focusNode: _focusNode1,
                  hintText: 'Enter your first name',
                  keyboardType: TextInputType.name,
                ),
                 
            AppTextField(
                  title: 'Phone Number',
                  onChanged: (a) {
                    _phoneNumberController.text = a;
                  },
                  onEditingComplete: _loseFocus,
                  focusNode: _focusNode2,
                  hintText: 'Enter your phone number',
                  keyboardType: TextInputType.number,
                ),
            AppTextField(title: 'Pharmay Name', onChanged: (a){
                  _pharmacyNameController.text=a;
                }, onEditingComplete: _loseFocus, 
                focusNode: _focusNode3,
                 hintText: 'Enter your pharmacy name', 
                 keyboardType: TextInputType.name),
                 AppTextField(
                  title: 'Door no/building no',
                  onChanged: (a) {
                    _dNoController.text = a;
                  },
                  onEditingComplete: _loseFocus,
                  focusNode: _focusNode4,
                  // ignore: unnecessary_string_escapes
                  hintText: 'Enter your pharmacy door no / building no',
                  keyboardType: TextInputType.name,
                ),
                AppTextField(
                  title: 'Street ',
                  onChanged: (a) {
                    _streetController.text = a;
                  },
                  onEditingComplete: _loseFocus,
                  focusNode: _focusNode5,
                  hintText: 'Enter name of street',
                  keyboardType: TextInputType.name,
                ),
                AppTextField(
                  title: 'City',
                  onChanged: (a) {
                    _cityController.text = a;
                  },
                  onEditingComplete: _loseFocus,
                  focusNode: _focusNode6,
                  hintText: 'Enter name of city ',
                  keyboardType: TextInputType.name,
                ),
                AppTextField(
                  title: 'PinCode',
                  onChanged: (a) {
                    _pinCodeController.text = a;
                  },
                  onEditingComplete: _loseFocus,
                  focusNode: _focusNode7,
                  hintText: 'Enter your pincode ',
                  keyboardType: TextInputType.number,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child:  Padding(
                     padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                    child: Text(" State",
                    style: TextStyle(
                    fontWeight: FontWeight.w500,
                                ),),
                  ),
                ),
                Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200], // Set the background color
                        borderRadius:
                            BorderRadius.circular(100), // Add rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16,),
                    child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      hintText: 'Select your state',
                       border: UnderlineInputBorder(
                      borderSide: BorderSide.none, // Remove the border line
                    ),
                    ),
                    value: selectedState,
                    focusColor: Colors.transparent, // Set focus color to transparent
                    items: states.map((state) {
                      return DropdownMenuItem<String>(
                        value: state,
                        child: Text(state),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedState = value!;
                      });
                    },
                                ),
                  ),
                ),

                       
                CustomElevatedButton(
                  onTap: () {
                   // updateVendorData();
                   updateVendorsData();
                  },
                  text: "Create account".toUpperCase(),
                  margin: const EdgeInsets.only(
                    top: 40,
                  ),
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        25,
                      ),
                    ),
                    shadowColor: ColorConstants.indigo.withOpacity(0.1),
                    elevation: 12,
                  ).copyWith(
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(
                        double.maxFinite,
                        50,
                      ),
                    ),
                  ),
                ),
                 const SizedBox(height: 30,)
          ],
        )),
      ),
    );
  }
}