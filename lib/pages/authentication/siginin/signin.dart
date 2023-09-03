import 'package:flutter/material.dart';
import 'package:gangaaramtech/pages/authentication/phoneauth/phoneauth.dart';
import 'package:gangaaramtech/repository/auth.dart';
import 'package:gangaaramtech/utils/constants/color_constants.dart';
import 'package:gangaaramtech/utils/constants/font_constants.dart';
import 'package:gangaaramtech/utils/constants/image_constants.dart';
import 'package:gangaaramtech/utils/widgets/custom_elevated_button.dart';
import 'package:gangaaramtech/utils/widgets/custom_outlined_button.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                height: 260,
                width: 258,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 258,
                        width: 258,
                        decoration: BoxDecoration(
                          // color: appTheme.indigoA400.withOpacity(0.03),
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
                  "Welcome to Medical App",
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
                      builder: (context) => const PhoneAuth(),
                    ),
                  );
                },
                text: "Sign in with phone number".toUpperCase(),
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
                  Auth().signInWithGoogle(context);
                },
                text: "Continue with Gmail".toUpperCase(),
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                leftIcon: Container(
                  margin: const EdgeInsets.only(
                    right: 19,
                  ),
                  child: Image.asset(ImageConstants.google),
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
              // Padding(
              //   padding: const EdgeInsets.only(
              //     top: 14,
              //     bottom: 1,
              //   ),
              //   child: Text(
              //     "sign up ".toUpperCase(),
              //     overflow: TextOverflow.ellipsis,
              //     textAlign: TextAlign.left,
              //     style: FontConstants.lightVioletMixedGreyNormal14,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
