// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gangaaramtech/Vendor/VHome/VendorHome.dart';
import 'package:gangaaramtech/repository/firestorefunctions.dart';
//import 'package:gangaaramtech/Vendor/VendorInforScreens/VendorInfo2.dart';
import 'package:gangaaramtech/utils/constants/color_constants.dart';
import 'package:gangaaramtech/utils/constants/font_constants.dart';
import 'package:gangaaramtech/utils/widgets/app_textfield.dart';
import 'package:gangaaramtech/utils/widgets/custom_elevated_button.dart';
List<String> states = [
  'Andhra Pradesh',
  'Arunachal Pradesh',
  'Assam',
  'Bihar',
  'Chhattisgarh',
  'Goa',
  'Gujarat',
  'Haryana',
  'Himachal Pradesh',
  'Jharkhand',
  'Karnataka',
  'Kerala',
  'Madhya Pradesh',
  'Maharashtra',
  'Manipur',
  'Meghalaya',
  'Mizoram',
  'Nagaland',
  'Odisha',
  'Punjab',
  'Rajasthan',
  'Sikkim',
  'Tamil Nadu',
  'Telangana',
  'Tripura',
  'Uttar Pradesh',
  'Uttarakhand',
  'West Bengal',
];


class VendorInformation extends StatefulWidget {
  final String phone;
  const VendorInformation({super.key, required this.phone});
  @override
  State<VendorInformation> createState() => _VendorInformationState();
}

class _VendorInformationState extends State<VendorInformation> {
  String selectedState = 'Andhra Pradesh'; 
  final _pharmacyNameController = TextEditingController();
  final _nameController=TextEditingController();
  final _emailController= TextEditingController();
  final _dNoController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pinCodeController = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4= FocusNode();
  final FocusNode _focusNode5= FocusNode();
  final FocusNode _focusNode6= FocusNode();
  final FocusNode _focusNode7= FocusNode();
  final FocusNode _focusNode8 = FocusNode();
  final FocusNode _focusNode9= FocusNode();


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
    _focusNode9.dispose();
    _nameController.dispose();
    _pharmacyNameController.dispose();
    _emailController.dispose();
    _stateController.dispose();
    _streetController.dispose();
    _dNoController.dispose();
    _pinCodeController.dispose();
    _cityController.dispose();
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
    _focusNode9.unfocus();
  }

void updateUsersData() async {
    // final firebaseAuth = FirebaseAuth.instance;
    String res = await FireStoreFunctions().updateUsersData(
      name: _nameController.text,
      email: _emailController.text,
      phone: widget.phone,
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
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
      child: SafeArea(
        child: Column(
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
                  title: 'Email',
                  onChanged: (a) {
                    _emailController.text = a;
                  },
                  onEditingComplete: _loseFocus,
                  focusNode: _focusNode2,
                  hintText: 'Enter your email address',
                  keyboardType: TextInputType.emailAddress,
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
                  hintText: 'Enter your pharmacy door no / building np',
                  keyboardType: TextInputType.name,
                ),
                 
                AppTextField(
                  title: 'Street ',
                  onChanged: (a) {
                    _streetController.text = a;
                  },
                  onEditingComplete: _loseFocus,
                  focusNode: _focusNode6,
                  hintText: 'Enter name of street',
                  keyboardType: TextInputType.name,
                ),
                AppTextField(
                  title: 'City',
                  onChanged: (a) {
                    _cityController.text = a;
                  },
                  onEditingComplete: _loseFocus,
                  focusNode: _focusNode7,
                  hintText: 'Enter name of city ',
                  keyboardType: TextInputType.name,
                ),
                AppTextField(
                  title: 'PinCode',
                  onChanged: (a) {
                    _pinCodeController.text = a;
                  },
                  onEditingComplete: _loseFocus,
                  focusNode: _focusNode8,
                  hintText: 'Enter your pincode ',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20,),
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
                    updateUsersData(); 
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
        ),
      ),
    ),);
  }
}