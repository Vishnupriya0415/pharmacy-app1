// // ignore_for_file: avoid_print

// import 'dart:convert';
// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:gangaaramtech/repository/file_upload.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:uuid/uuid.dart';

// class ImageUploadScreen extends StatefulWidget {
//   const ImageUploadScreen({super.key});

//   @override
//   State<ImageUploadScreen> createState() => _ImageUploadScreenState();
// }

// class _ImageUploadScreenState extends State<ImageUploadScreen> {
//   File? _imageFile;

//   Future<void> _pickImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//         print(_imageFile);
//       });
//       _uploadImageToFirebaseStorage();
//     }
//   }

//   final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
//   String fileurl = '';

//   Future<void> _uploadImageToFirebaseStorage() async {
//     try {
//       // Make random image file name
//       String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
//       String descId = const Uuid().v1();
//       // Upload image to firebase storage
//       await FileStoreMethods()
//           .fileUpload(_imageFile!, 'description', imageFileName, descId);
//       // fileurl
//       String fileUrl = await _firebaseStorage
//           .ref()
//           .child('description')
//           .child(FirebaseAuth.instance.currentUser!.displayName!)
//           .child(imageFileName)
//           .child(descId)
//           .getDownloadURL();
//       print(fileUrl);
//       setState(() {
//         fileurl = fileUrl;
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   final String _apiUrl =
//       'https://ee5yeyxx2e.execute-api.ap-south-1.amazonaws.com/v1/image-text';

//   String extractedText = '';

//   Future<void> sendImageToAPI() async {
//     try {
//       print(fileurl);

//       // Map<String, dynamic> requestBody = {
//       //   'body': fileurl,
//       // };

//       String requestBody = fileurl;

//       // Send the POST request to the API
//       http.Response response = await http.post(
//         Uri.parse(_apiUrl),
//         body: requestBody,
//         headers: {
//           'Content-Type': 'text/plain',
//         },
//       );
//       print(response.statusCode);
//       if (response.statusCode == 200) {
//         Map<String, dynamic> responseData = jsonDecode(response.body);
//         extractedText = responseData['extracted_text'];
//         setState(() {
//           extractedText = extractedText;
//         });
//         print(extractedText);
//       } else {
//         print('API Call Failed: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Image Upload')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             if (_imageFile != null) Image.file(_imageFile!),
//             ElevatedButton(
//               onPressed: _pickImage,
//               child: const Text('Select Image'),
//             ),
//             if (_imageFile != null)
//               ElevatedButton(
//                 onPressed: () async {
//                   // sendImageToAPI(_imageFile!);
//                   sendImageToAPI();
//                 },
//                 child: const Text('Send Image to API'),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/repository/file_upload.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _imageFile;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        print(_imageFile);
      });
      _uploadImageToFirebaseStorage();
    }
  }

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String fileurl = '';

  Future<void> _uploadImageToFirebaseStorage() async {
    setState(() {
      _isUploading = true;
    });

    try {
      // Make random image file name
      String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
      String descId = const Uuid().v1();
      // Upload image to firebase storage
      await FileStoreMethods()
          .fileUpload(_imageFile!, 'description', imageFileName, descId);
      // fileurl
      String fileUrl = await _firebaseStorage
          .ref()
          .child('description')
          .child(FirebaseAuth.instance.currentUser!.displayName!)
          .child(imageFileName)
          .child(descId)
          .getDownloadURL();
      print(fileUrl);
      setState(() {
        fileurl = fileUrl;
        _isUploading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isUploading = false;
      });
    }
  }

  final String _apiUrl =
      'https://ee5yeyxx2e.execute-api.ap-south-1.amazonaws.com/v1/image-text';

  String extractedText = '';

  Future<void> sendImageToAPI() async {
    try {
      print(fileurl);

      String requestBody = fileurl;

      // Send the POST request to the API
      http.Response response = await http.post(
        Uri.parse(_apiUrl),
        body: requestBody,
        headers: {
          'Content-Type': 'text/plain',
        },
      );

      if (response.statusCode == 200) {
        // Successful API call
        // Parse the response JSON
        Map<String, dynamic> responseData = jsonDecode(response.body);
        // Access the extracted text from the response
        String extractedText = responseData['extracted_text'];
        setState(() {
          this.extractedText = extractedText;
        });
      } else {
        // API call failed
        print('API Call Failed: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Upload')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_imageFile != null)
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.file(_imageFile!),
                  if (_isUploading) const CircularProgressIndicator(),
                ],
              ),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Select Image'),
            ),
            if (_imageFile != null)
              ElevatedButton(
                onPressed: () async {
                  sendImageToAPI();
                },
                child: const Text('Send Image to API'),
              ),
            if (extractedText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Extracted Text: $extractedText'),
              ),
          ],
        ),
      ),
    );
  }
}
