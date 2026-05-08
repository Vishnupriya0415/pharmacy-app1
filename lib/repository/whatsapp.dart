// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class WhatsappImage extends StatelessWidget {
  WhatsappImage({Key? key}) : super(key: key);
  final ScreenshotController _controller = ScreenshotController();
  File? _image;

  Future<void> share() async {
    await Share.share('Example share text https://flutter.dev/');
  }

  Future<void> shareFile1() async {
    await getImage();
    if (_image != null) {
      await Share.shareXFiles([XFile(_image!.path)], text: "hello");
    }
  }

  ///Pick Image From gallery using image_picker plugin
  Future getImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? pickedFile = (await picker.pickImage(source: ImageSource.gallery));

      if (pickedFile != null) {
        // getting a directory path for saving
        final directory = await getExternalStorageDirectory();

        // copy the file to a new path
        await pickedFile.saveTo('${directory!.path}/image1.png');
        _image = File('${directory.path}/image1.png');
      }
    } catch (er) {
      // print(er);
      debugPrint('Error picking image: $er');
    }
  }

  Future<void> isInstalled() async {
    debugPrint('Whatsapp check not natively supported by share_plus.');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Whatsapp Share'),
        ),
        body: Center(
          child: Screenshot(
            controller: _controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: share,
                  child: const Text('Share text and link'),
                ),
                ElevatedButton(
                  onPressed: () => shareFile1(),
                  child: const Text('Share Image with error'),
                ),
                ElevatedButton(
                  onPressed: isInstalled,
                  child: const Text('is Installed'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
