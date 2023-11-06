import 'package:flutter/material.dart';

class CurvedAlertDialogBox1 extends StatelessWidget {
  final String title;
  final String additionalText;
  final VoidCallback? onClosePressed;
  final VoidCallback? onSubmitPressed;

  const CurvedAlertDialogBox1({
    key,
    required this.title,
    required this.additionalText,
    this.onClosePressed,
    this.onSubmitPressed,
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
                  child: const Icon(
                    Icons.cancel,
                    size: 30,
                    color: Colors.black,
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
            Text(
              additionalText,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  if (onSubmitPressed != null) {
                    onSubmitPressed!();
                  }
                },
                child: const Text('Yes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
