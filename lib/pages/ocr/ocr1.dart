// // GOGGLE ML KIT

// // ignore_for_file: avoid_print

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';

// class OCR1 extends StatefulWidget {
//   const OCR1({Key? key}) : super(key: key);

//   @override
//   State<OCR1> createState() => _OCR1State();
// }

// class _OCR1State extends State<OCR1> {
//   String result = '';
//   File? _image;
//   InputImage? inputImage;
//   final picker = ImagePicker();

//   // Future pickImageFromGallery() async {
//   //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//   //   if (pickedFile != null) {
//   //     setState(() {
//   //       _image = File(pickedFile.path);
//   //       inputImage = InputImage.fromFilePath(pickedFile.path);
//   //       imageToText(inputImage!);
//   //     });
//   //   } else {
//   //     print('No image selected.');
//   //   }
//   // }

//   // Future captureImageFromCamera() async {
//   //   final pickedFile = await picker.pickImage(source: ImageSource.camera);

//   //   if (pickedFile != null) {
//   //     setState(() {
//   //       _image = File(pickedFile.path);
//   //       inputImage = InputImage.fromFilePath(pickedFile.path);
//   //       imageToText(inputImage!);
//   //     });
//   //   } else {
//   //     print('No image selected.');
//   //   }
//   // }

//   Future imageToText(InputImage inputImage) async {
//     setState(() {
//       result = ''; // Clear the previous result before processing the new image
//     });

//     final textDetector = GoogleMlKit.vision.textRecognizer();
//     final RecognizedText recognisedText =
//         await textDetector.processImage(inputImage);

//     setState(() {
//       // String text = recognisedText.text;
//       for (TextBlock block in recognisedText.blocks) {
//         //each block of text/section of text
//         for (TextLine line in block.lines) {
//           //each line within a text block
//           for (TextElement element in line.elements) {
//             //each word within a line
//             result += "${element.text} ";
//           }
//           result += "\n"; // Add a new line after each line of text
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:
//           AppBar(title: const Text('OCR Text Extraction Using Google ML Kit')),
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
//             // ElevatedButton(
//             //   onPressed: pickImageFromGallery,
//             //   child: const Text('Pick Image from Gallery'),
//             // ),
//             // const SizedBox(height: 10),
//             // ElevatedButton(
//             //   onPressed: captureImageFromCamera,
//             //   child: const Text('Capture Image from Camera'),
//             // ),
//             // const SizedBox(height: 20),
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
