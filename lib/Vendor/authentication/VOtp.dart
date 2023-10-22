// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:gangaaramtech/Vendor/VHome/VendorHome.dart';
import 'package:gangaaramtech/Vendor/VendorInforScreens/VendorInfo1.dart';
import 'package:gangaaramtech/Vendor/authentication/Vauth.dart';
import 'package:gangaaramtech/utils/constants/color_constants.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class VOtpVerify extends StatefulWidget {
  final String phone;
  final String verificationId;
  const VOtpVerify(
      {super.key, required this.verificationId, required this.phone});

  @override
  State<VOtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<VOtpVerify> {
  String? otpCode;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            ),
          ),
          elevation: 0,
        ),
        body: Container(
          margin: const EdgeInsets.only(left: 25, right: 25),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/phone.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  "Verification",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Enter the OTP sent to your Phone Number",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                Pinput(
                  length: 6,
                  showCursor: true,
                  defaultPinTheme: PinTheme(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: ColorConstants.indigo,
                      ),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onCompleted: (value) {
                    setState(() {
                      otpCode = value;
                      print(otpCode);
                    });
                  },
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          56,
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (otpCode != null) {
                        verifyOtp(context, otpCode!);
                      } else {
                        const ScaffoldMessenger(
                          child: SnackBar(
                            content: Text("Enter 6-Digit code"),
                          ),
                        );
                      }
                    },
                    child: const Text("Verify"),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Didn't receive any code?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    "Resend New Code",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
  void verifyOtp(BuildContext context, String userOtp) {
    final ap = Provider.of<VAuth>(context, listen: false);
    ap.verifyOtp(
      context: context,
      verificationId: widget.verificationId,
      vendorOtp: userOtp,
      onSuccess: () {
        // checking whether user exists in the db
        ap.checkExistingUser().then(
          (value) async {
            if (value == true) {
              // user exists in our app
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VendorHome(),
                ),
              );
            } else {
              //new user
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => VendorInformation(phone: widget.phone,)
                ),
                (route) => false,
              );
            }
          },
        );
      },
    );
  }
}
