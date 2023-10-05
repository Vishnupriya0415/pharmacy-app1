// ignore_for_file: use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:gangaaramtech/Vendor/authentication/Vauth.dart';
import 'package:gangaaramtech/utils/constants/color_constants.dart';

class VPhoneAuth extends StatefulWidget {
  const VPhoneAuth({super.key});

  @override
  State<VPhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<VPhoneAuth> {
  TextEditingController phoneController = TextEditingController();

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    VAuth().phoneVerification(
        context, "+${selectedCountry.phoneCode}$phoneNumber");
  }

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: phoneController.text.length,
      ),
    );
    return SafeArea(
      child: Scaffold(
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
                  "Phone Number Verification",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "We need to register your phone before getting started!",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        onChanged: (value) {
                          setState(() {
                            phoneController.text = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Phone",
                          prefixIcon: Container(
                            padding: const EdgeInsets.all(10),
                            child: InkWell(
                              onTap: () {
                                showCountryPicker(
                                    context: context,
                                    countryListTheme:
                                        const CountryListThemeData(
                                      bottomSheetHeight: 550,
                                    ),
                                    onSelect: (value) {
                                      setState(() {
                                        selectedCountry = value;
                                      });
                                    });
                              },
                              child: Text(
                                "${selectedCountry.flagEmoji}+${selectedCountry.phoneCode}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          suffixIcon: phoneController.text.length == 10
                              ? Container(
                                  height: 30,
                                  width: 30,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                  ),
                                  child: const Icon(
                                    Icons.done,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                )
                              : null,
                        ),
                      ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(56),
                      ),
                    ),
                    onPressed: () {
                      sendPhoneNumber();
                    },
                    child: Text("Next".toUpperCase()),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
