// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CurvedAlertDialogBox1 extends StatelessWidget {
  final String title;
  final String additionalText;
  final VoidCallback? onClosePressed;
  final VoidCallback? onYesPressed;
  final VoidCallback? onNoPressed;

  const CurvedAlertDialogBox1({
    Key? key,
    required this.title,
    required this.additionalText,
    this.onClosePressed,
    this.onYesPressed,
    this.onNoPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  if (onClosePressed != null) {
                    onClosePressed!();
                  }
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.cancel,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8), // Add some spacing
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                additionalText,
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    if (onNoPressed != null) {
                      onNoPressed!();
                    }
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    if (onYesPressed != null) {
                      onYesPressed!();
                    }
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
