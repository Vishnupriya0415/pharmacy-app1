// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gangaaramtech/pages/home/home.dart';
import 'package:gangaaramtech/repository/firestorefunctions.dart';
import 'package:gangaaramtech/utils/constants/color_constants.dart';
import 'package:gangaaramtech/utils/constants/font_constants.dart';
import 'package:gangaaramtech/utils/constants/image_constants.dart';
import 'package:gangaaramtech/utils/widgets/app_textfield.dart';
import 'package:gangaaramtech/utils/widgets/custom_elevated_button.dart';

class UserInfromationScreen extends StatefulWidget {
  final String phone;
  // const OtpVerify(
  //     {super.key, required this.verificationId, required this.phone});

  const UserInfromationScreen({super.key, required this.phone});

  @override
  State<UserInfromationScreen> createState() => _UserInfromationScreenState();
}

class _UserInfromationScreenState extends State<UserInfromationScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dOBController = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _dOBController.dispose();
    super.dispose();
  }

  void _loseFocus() {
    _focusNode1.unfocus();
    _focusNode2.unfocus();
    _focusNode3.unfocus();
  }

  void updateUserData() async {
    // final firebaseAuth = FirebaseAuth.instance;
    String res = await FireStoreFunctions().updateUserData(
      name: _nameController.text,
      email: _emailController.text,
      // phone: firebaseAuth.currentUser!.phoneNumber!,
      // phone: '+917904480400',
      phone: widget.phone,
    );
    if (res == 'success') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            padding:
                const EdgeInsets.only(left: 24, top: 16, right: 24, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    ImageConstants.imgArrowLeft,
                    height: 24,
                    width: 24,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 30, bottom: 30),
                  child: Text(
                    "Create your account",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    // style: theme.textTheme.headlineSmall,
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
                  focusNode: _focusNode3,
                  hintText: 'Enter your email address',
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomElevatedButton(
                  onTap: () {
                    updateUserData();
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
                  buttonTextStyle: FontConstants.button,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
