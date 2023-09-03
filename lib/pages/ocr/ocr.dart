// // tesseract

// // ignore_for_file: avoid_print

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

// class OCR extends StatefulWidget {
//   const OCR({Key? key}) : super(key: key);

//   @override
//   State<OCR> createState() => _OCRState();
// }

// class _OCRState extends State<OCR> {
//   String result = '';
//   File? _image;
//   final picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the OCR process when the app starts
//     performOCR();
//   }

//   Future pickImageFromGallery() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         performOCR();
//       });
//     } else {
//       print('No image selected.');
//     }
//   }

//   Future captureImageFromCamera() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.camera);

//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         performOCR();
//       });
//     } else {
//       print('No image selected.');
//     }
//   }

//   Future performOCR() async {
//     if (_image != null) {
//       try {
//         final text = await FlutterTesseractOcr.extractText(_image!.path);
//         print('OCR Result: $text');
//         setState(() {
//           result = text;
//         });
//       } catch (e) {
//         print('Error while performing OCR: $e');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('OCR Text Extraction using Tesseract')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (_image != null)
//               Image.file(
//                 _image!,
//                 width: 300,
//                 height: 300,
//               ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: pickImageFromGallery,
//               child: const Text('Pick Image from Gallery'),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: captureImageFromCamera,
//               child: const Text('Capture Image from Camera'),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Text(
//                     result,
//                     style: const TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
