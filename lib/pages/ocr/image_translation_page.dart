import 'dart:io';

import 'package:flutter/material.dart';

class ImageTranslationPage extends StatelessWidget {
  final String extractedText;
  final File imageFile;

  const ImageTranslationPage(
      {super.key, required this.extractedText, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Translation'),
      ),
      body: Column(
        children: [
          // Display the image
          Container(
            height: 200,
            width: 200,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(imageFile),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          // Display the extracted text
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  extractedText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
