// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:whatsapp_share/whatsapp_share.dart';

class WhatsappImage extends StatelessWidget {
  WhatsappImage({Key? key}) : super(key: key);
  final ScreenshotController _controller = ScreenshotController();
  File? _image;

  Future<void> share() async {
    await WhatsappShare.share(
      text: 'Example share text',
      linkUrl: 'https://flutter.dev/',
      phone: '911234567890',
    );
  }

  Future<void> shareFile1() async {
    await getImage();
    await WhatsappShare.shareFile(
      phone: "918438006590",
      filePath: [(_image!.path)],
    );
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
    final val = await WhatsappShare.isInstalled(package: Package.whatsapp);
    debugPrint('Whatsapp is installed: $val');
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
