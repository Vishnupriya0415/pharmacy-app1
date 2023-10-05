// ignore_for_file: sized_box_for_whitespace, file_names

import 'package:flutter/material.dart';
import 'package:gangaaramtech/Vendor/authentication/SignIn.dart';
import 'package:gangaaramtech/pages/authentication/siginin/signin.dart';
import 'package:gangaaramtech/utils/constants/color_constants.dart';
import 'package:gangaaramtech/utils/constants/font_constants.dart';
import 'package:gangaaramtech/utils/constants/image_constants.dart';
import 'package:gangaaramtech/utils/widgets/custom_elevated_button.dart';
import 'package:gangaaramtech/utils/widgets/custom_outlined_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUScreenState();
}

class _SignUScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: 
    Scaffold(
      backgroundColor: ColorConstants.white,
      body: Container(
        width: double.maxFinite,
          padding: const EdgeInsets.only(
            left: 32,
            right: 32,
          ),
          child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 250,
                width: 250,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                   Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 258,
                        width: 258,
                        decoration: BoxDecoration(
                          color: ColorConstants.indigo.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(129),
                        ),
                      ),
                    ),
                    Image.asset(
                      ImageConstants.welcome,
                      height: 219,
                      width: 258,
                      alignment: Alignment.bottomCenter,
                    ), 
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                ),
                child: Text(
                  "Welcome to MedRover",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: FontConstants.lightVioletNormal24,
                ),
                
              ),
              Container(
                width: 233,
                margin: const EdgeInsets.only(
                  left: 39,
                  top: 15,
                  right: 38,
                ),
                child: Text(
                  "Do you want some help with your health to get better life?",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: FontConstants.lightVioletMixedGreyNormal16,
                ),
              ),
              CustomElevatedButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignIn(),
                    ),
                  );
                },
                leftIcon:Container(
                  margin:const EdgeInsets.only(right: 19),
                  child: const   Icon(Icons.person)),
                text: "Sign in as user".toUpperCase(),
                margin: const EdgeInsets.only(
                  top: 31,
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
              const SizedBox(
                height: 20,
              ),
              CustomOutlinedButton(
                onTap: () {
                 Navigator.push(
                              context,
               MaterialPageRoute(builder: (context) => const VSignIn()),
                                );

                },
                leftIcon:Container(
                  margin:const EdgeInsets.only(right: 19),
                  child: const   Icon(Icons.medical_services)),
                text: "Sign in as Vendor".toUpperCase(),
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                buttonStyle: OutlinedButton.styleFrom(
                  backgroundColor: ColorConstants.white,
                  side: BorderSide(
                    color: const Color(0X26090F47).withOpacity(0.1),
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      25,
                    ),
                  ),
                ).copyWith(
                  fixedSize: MaterialStateProperty.all<Size>(
                    const Size(double.maxFinite, 50),
                  ),
                ),
                buttonTextStyle: FontConstants.button,
              ),

            ],
          )
      ),
    ));
  }
}
