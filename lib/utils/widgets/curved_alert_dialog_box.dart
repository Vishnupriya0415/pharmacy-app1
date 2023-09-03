// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CurvedAlertDialog extends StatelessWidget {
  final String title;
  final VoidCallback? onClosePressed;
  final Function(String)? onImageSelected;

  const CurvedAlertDialog({
    super.key,
    required this.title,
    this.onClosePressed,
    this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();

    return AlertDialog(
      content: SizedBox(
        width: 330,
        height: 220,
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
                    margin: const EdgeInsets.only(left: 150, bottom: 10),
                    padding: const EdgeInsets.only(
                        left: 7, top: 8, right: 7, bottom: 8),
                    decoration: BoxDecoration(
                      // color: const Color(0XFFFFC000),
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 4),
                            child: const Image(
                              image: AssetImage(
                                'assets/images/cancel.png',
                              ),
                              height: 24,
                              width: 24,
                              alignment: Alignment.center,
                            ),
                          ),
                        ],
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async {
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.camera,
                      preferredCameraDevice: CameraDevice.rear,
                    );
                    Navigator.pop(context); // Close the dialog
                    if (pickedFile != null) {
                      if (onImageSelected != null) {
                        onImageSelected!(pickedFile.path);
                      }
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 11, top: 18),
                        padding: const EdgeInsets.only(
                            left: 7, top: 8, right: 7, bottom: 8),
                        decoration: BoxDecoration(
                          // color: const Color(0XFFFFC000),
                          color: Colors.blue,

                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: SizedBox(
                          height: 48,
                          width: 48,
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 12),
                                child: const Image(
                                  image: AssetImage(
                                    'assets/images/camera.png',
                                  ),
                                  height: 24,
                                  width: 24,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('Camera'),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                GestureDetector(
                  onTap: () async {
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    Navigator.pop(context); // Close the dialog
                    if (pickedFile != null) {
                      if (onImageSelected != null) {
                        onImageSelected!(pickedFile.path);
                      }
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 1, top: 18),
                        padding: const EdgeInsets.only(
                            left: 7, top: 8, right: 7, bottom: 8),
                        decoration: BoxDecoration(
                          // color: const Color(0XFFFFC000),
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: SizedBox(
                          height: 48,
                          width: 48,
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 12),
                                child: const Image(
                                  image: AssetImage(
                                    'assets/images/gallery.png',
                                  ),
                                  height: 24,
                                  width: 24,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('Gallery'),
                    ],
                  ),
                ),
                // const SizedBox(width: 14),
                // GestureDetector(
                //   onTap: onClosePressed ??
                //       () {
                //         Navigator.pop(context); // Close the dialog
                //       },
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       Container(
                //         margin: const EdgeInsets.only(left: 1, top: 18),
                //         padding: const EdgeInsets.only(
                //             left: 7, top: 8, right: 7, bottom: 8),
                //         decoration: BoxDecoration(
                //           color: const Color(0XFFFFC000),
                //           borderRadius: BorderRadius.circular(32),
                //         ),
                //         child: SizedBox(
                //           height: 48,
                //           width: 48,
                //           child: Stack(
                //             alignment: Alignment.centerRight,
                //             children: [
                //               Container(
                //                 margin: const EdgeInsets.only(right: 12),
                //                 child: const Image(
                //                   image: AssetImage(
                //                     'assets/images/cancel.png',
                //                   ),
                //                   height: 24,
                //                   width: 24,
                //                   alignment: Alignment.center,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //       const SizedBox(height: 8),
                //       const Text('Close'),
                //     ],
                //   ),
                // ),
              ],
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
