// ignore_for_file: deprecated_member_use, use_build_context_synchronously, library_private_types_in_public_api, use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MaterialApp(
    home: WhatsAppScreen(),
  ));
}

class WhatsAppScreen extends StatefulWidget {
  @override
  _WhatsAppScreenState createState() => _WhatsAppScreenState();
}

class _WhatsAppScreenState extends State<WhatsAppScreen> {
  File? _selectedImage;

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> sendWhatsAppMessage() async {
    // Phone number (with country code) of the recipient
    String phoneNumber =
        "919391135696"; // Replace with the recipient's phone number

    // Message text
    String messageText = "Hello, this is a test message.";

    // Check if an image is selected
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an image."),
        ),
      );
      return;
    }

    // Construct the WhatsApp URL with the message and image
    String whatsappUrl =
        "https://wa.me/$phoneNumber/?text=${Uri.encodeFull(messageText)}&media=${Uri.encodeFull(_selectedImage!.path)}";

    // Check if WhatsApp is installed and launch the URL
    
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on your device."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send WhatsApp Message"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                width: 200,
                height: 200,
              ),
            ElevatedButton(
              onPressed: () => pickImage(),
              child: const Text("Select Image"),
            ),
            ElevatedButton(
              onPressed: () => sendWhatsAppMessage(),
              child: const Text("Send WhatsApp Message"),
            ),
          ],
        ),
      ),
    );
  }
}
