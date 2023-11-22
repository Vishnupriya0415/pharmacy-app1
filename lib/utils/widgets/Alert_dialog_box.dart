// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CurvedAlertDialogBox extends StatelessWidget {
  final String title;
  final String hintText; // Label text for the text field
  final VoidCallback? onClosePressed;
  final TextEditingController? textController; // Text controller for user input
  final VoidCallback? onSubmitPressed;
  final TextInputType?
      keyboardType; // Keyboard type for the text field// Callback for the submit button

  const CurvedAlertDialogBox({
    super.key,
    required this.title,
    required this.hintText,
    this.onClosePressed,
    this.textController,
    this.onSubmitPressed,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 300,
        height: 250, // Increased height to accommodate the "Submit" button
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 150, bottom: 25),
                    padding: const EdgeInsets.only(
                        left: 7, top: 8, right: 7, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 4),
                              child: const Icon(
                                Icons.cancel, // Use the cancel icon
                                size: 40,
                                color:
                                    Colors.black, // You can customize the color
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Add a text field for user input
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  //  labelText: labelText,
                  hintText: hintText,
                  focusedBorder: InputBorder.none,
                  // Use the provided label text
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Add the "Submit" button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  if (onSubmitPressed != null) {
                    onSubmitPressed!();
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
}
