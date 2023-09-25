// ignore_for_file: avoid_print, use_build_context_synchronously, deprecated_member_use
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/MyOrdersPage.dart';
import 'package:gangaaramtech/pages/medicine_details_page/medicine_details_page.dart';
//import 'package:gangaaramtech/pages/OrderDetails/orderdetails.dart';
import 'package:http/http.dart' as http;
//import 'package:gangaaramtech/pages/search/search_page.dart';
import 'package:gangaaramtech/pages/search/search_page1.dart';
import 'package:gangaaramtech/pages/search_result_page/search_result_page.dart';
import 'package:gangaaramtech/pages/settings/settings.dart';
import 'package:gangaaramtech/utils/constants/color_constants.dart';
import 'package:gangaaramtech/utils/constants/image_constants.dart';
import 'package:gangaaramtech/utils/widgets/curved_alert_dialog_box.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whatsapp_share/whatsapp_share.dart';

class Home extends StatefulWidget {
  Home({super.key});
  final List<String> imagePaths = [
    'assets/images/medicine_Delivery1.png',
    'assets/images/tablets/delivery_medicine2.jpg',
    'assets/images/tablets/scan1.jpeg',
    'assets/images/deliveryMedicine2.jpg'
    // Add more image paths as needed
  ];

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> pharmacyData = [];
  File? imageFile; // Define the imageFile variable here
  Position? currentPosition;
  // final PageController _pageController = PageController();
  final PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction:
        0.8, // Set the fraction as desired to control visible images.
  );
  Timer? locationUpdateTimer;

  bool _disposed = false;
  final List<String> imageDescriptions = [
    'Medicine Delivery . We offer medicine delivery services for your convenience ',
    'Safe Delivery Service. We make sure medicines are brought to you safely and on time ',
    'Scan your Prescription.Easily upload your prescription for quick ordering . We\'ll  ensure safe delivery and prompt delivery for your doorstep.',
    'Order Medicines: Browse and select your medicines with ease. Pay online or choose Cash on Delivery, and get your order delivered to your doorstep'
  ];
  void _showImageDescription(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Spacer(),
              const CircleAvatar(
                radius: 25.0,
                backgroundImage: AssetImage('assets/images/tablets/logo1.png'),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 35,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                imageDescriptions[index],
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          // actions: [],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          backgroundColor: Colors.white, // Set the background color
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startLocationUpdateTimer();
    fetchMedicalStores();
  }

  @override
  void dispose() {
    super.dispose();
    locationUpdateTimer?.cancel();
    _disposed = true;
  }

  // void _startLocationUpdateTimer() {
  //   locationUpdateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
  //     _getCurrentLocation();
  //   });
  // }

  void _startLocationUpdateTimer() {
    locationUpdateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!_disposed) {
        _getCurrentLocation();
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceDisabledMessage();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showPermissionDeniedMessage();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showPermissionPermanentlyDeniedMessage();
      return;
    }

    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      setState(() {
        currentPosition = position;
      });
      _updateLocationToFirestore(position.latitude, position.longitude);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _updateLocationToFirestore(
      double latitude, double longitude) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String uid = auth.currentUser!.uid;

      print('uid is $uid');
      final List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isEmpty) {
        print('No placemarks found for the given coordinates.');
        // Handle the error condition when no placemarks are returned.
        return;
      }

      final Placemark place = placemarks.first;
      final String? name = place.name;
      final String? subLocality = place.subLocality;
      final String? locality = place.locality;
      final String? administrativeArea = place.administrativeArea;
      final String? postalCode = place.postalCode;
      final String? country = place.country;
      final String address =
          "$name, $subLocality, $locality, $administrativeArea, $postalCode, $country";

      await firestore.collection('users').doc(uid).update({
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
      });

      print('Updating location: $latitude, $longitude');
    } catch (e) {
      print('Geocoding error: $e');
      // Handle the error,  show an error message, or retry the operation.
    }
  }

  void _showPermissionDeniedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Location permission denied. Please enable it in the app settings.',
        ),
      ),
    );
  }

  void _showPermissionPermanentlyDeniedMessage() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text(
              'Location permission is permanently denied. Please enable it in the app settings.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLocationServiceDisabledMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Location service disabled. Please enable it in your device settings.',
        ),
      ),
    );
  }

  Future<void> pickDescriptionImage(BuildContext context) async {
    String? imagePath = await showDialog(
      context: context,
      builder: (BuildContext dialogContext) => CurvedAlertDialog(
        title: 'Choose image from',
        onImageSelected: (String imagePath) {
          setState(() {
            imageFile = File(imagePath);
            uploadProgress = 0.0; // Reset progress when a new image is selected
          });
          _uploadImage(imageFile!);
          // widget.onImageSelected(imagePath);
        },
        onClosePressed: () {
          Navigator.pop(context);
        },
      ),
    );

    if (imagePath != null) {
      // widget.onImageSelected(imagePath);
    }
  }

  double uploadProgress = 0.0;
  bool showImageAfterUpload =
      false; // Flag to control image visibility after upload

  Future<void> _uploadImage(File imageFile) async {
    // Simulate the image upload progress
    const totalDuration = Duration(seconds: 5);
    const intervalDuration = Duration(milliseconds: 500);
    int intervals =
        totalDuration.inMilliseconds ~/ intervalDuration.inMilliseconds;
    double stepProgress = 100 / intervals;

    for (int i = 1; i <= intervals; i++) {
      await Future.delayed(intervalDuration);
      setState(() {
        uploadProgress = stepProgress * i;
      });
    }

    // Reset progress after the upload is complete
    setState(() {
      uploadProgress = 0;
      showImageAfterUpload =
          true; // Set the flag to true after the upload is complete
    });

    // Show the AlertDialog when upload is complete
    if (showImageAfterUpload) {
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: SizedBox(
            width: 330, // Set the desired width
            height: 200, // Set the desired height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/images/file-text.png'),
                  height: 70,
                  width: 70,
                ),
                const SizedBox(height: 16),
                Text(
                  'Uploaded Successfully',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 130,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(130, 50),
                      // backgroundColor: kYellow,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Done ",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Image(
                          image: AssetImage('assets/images/ok_vector.png'),
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
      );
    }

    // After the upload is complete, perform image-to-text translation
    // String extractedText = await performImageToTextTranslation(imageFile);

    // Navigate to the ImageTranslationPage and pass the extracted text and imageFile as arguments
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ImageTranslationPage(
    //       extractedText: extractedText,
    //       imageFile: imageFile,
    //     ),
    //   ),
    // );
  }

  // Future<void> pickDescriptionImageWhatsapp(BuildContext context) async {
  //   String? imagePath = await showDialog(
  //     context: context,
  //     builder: (BuildContext dialogContext) => CurvedAlertDialog(
  //       title: 'Choose image from',
  //       onImageSelected: (String imagePath) {
  //         setState(() {
  //           imageFile = File(imagePath);
  //           uploadProgress = 0.0; // Reset progress when a new image is selected
  //         });
  //         _uploadImage1(imageFile!);
  //         // widget.onImageSelected(imagePath);
  //       },
  //       onClosePressed: () {
  //         Navigator.pop(context);
  //       },
  //     ),
  //   );

  //   if (imagePath != null) {
  //     // widget.onImageSelected(imagePath);
  //   }
  // }

  // double uploadProgress1 = 0.0;
  // bool showImageAfterUpload1 =
  //     false; // Flag to control image visibility after upload

  // Future<void> _uploadImage1(File imageFile) async {
  //   // Simulate the image upload progress
  //   const totalDuration = Duration(seconds: 5);
  //   const intervalDuration = Duration(milliseconds: 500);
  //   int intervals =
  //       totalDuration.inMilliseconds ~/ intervalDuration.inMilliseconds;
  //   double stepProgress = 100 / intervals;

  //   for (int i = 1; i <= intervals; i++) {
  //     await Future.delayed(intervalDuration);
  //     setState(() {
  //       uploadProgress = stepProgress * i;
  //     });
  //   }

  //   // Reset progress after the upload is complete
  //   setState(() {
  //     uploadProgress = 0;
  //     showImageAfterUpload =
  //         true; // Set the flag to true after the upload is complete
  //   });

  //   // Show the AlertDialog when upload is complete
  //   if (showImageAfterUpload) {
  //     await showDialog(
  //       context: context,
  //       builder: (BuildContext context) => AlertDialog(
  //         content: SizedBox(
  //           width: 330, // Set the desired width
  //           height: 200, // Set the desired height
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               const Image(
  //                 image: AssetImage('assets/images/file-text.png'),
  //                 height: 70,
  //                 width: 70,
  //               ),
  //               const SizedBox(height: 16),
  //               Text(
  //                 'Uploaded Successfully',
  //                 style: GoogleFonts.poppins(
  //                   fontSize: 15,
  //                   color: Colors.black,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //               const SizedBox(height: 16),
  //               SizedBox(
  //                 width: 130,
  //                 height: 50,
  //                 child: ElevatedButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     minimumSize: const Size(130, 50),
  //                     // backgroundColor: kYellow,
  //                     backgroundColor: Colors.blue,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(30),
  //                     ),
  //                   ),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Text(
  //                         "Done ",
  //                         style: GoogleFonts.poppins(
  //                           fontSize: 16,
  //                           color: Colors.black,
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                       ),
  //                       const SizedBox(width: 5),
  //                       const Image(
  //                         image: AssetImage('assets/images/ok_vector.png'),
  //                         width: 24,
  //                         height: 24,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(40.0),
  //         ),
  //       ),
  //     );
  //   }

  //   // After the upload is complete, perform image-to-text translation
  //   // String extractedText = await performImageToTextTranslation(imageFile);

  //   // Navigate to the ImageTranslationPage and pass the extracted text and imageFile as arguments
  //   // Navigator.push(
  //   //   context,
  //   //   MaterialPageRoute(
  //   //     builder: (context) => ImageTranslationPage(
  //   //       extractedText: extractedText,
  //   //       imageFile: imageFile,
  //   //     ),
  //   //   ),
  //   // );
  // }

  File? _image;

  Future<void> isInstalled() async {
    final val = await WhatsappShare.isInstalled(package: Package.whatsapp);
    if (val == true) {
      debugPrint('Whatsapp is installed: $val');
      shareFile1();
    } else {
      debugPrint('Whatsapp is not installed: $val');
      _showWhatsappNotInstalledDialog();
    }
    // debugPrint('Whatsapp is installed: $val');
  }

  void _showWhatsappNotInstalledDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Whatsapp Not Installed'),
        content: const Text(
            'Whatsapp is not installed on your device. Please install it from the Play Store/App Store.'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> shareFile1() async {
    await getImage();
    await WhatsappShare.shareFile(
      text: "hello ",
      phone: "919391135696",
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
      // show error message to the user.
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Gallery'),
          content: const Text(
              'There was an error while picking the image. Please try again.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      debugPrint('Error picking image: $er');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int currentIndex = 0;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(right: 1),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              if (index == currentIndex) {
                return;
              }
              setState(() {
                currentIndex = index;
              });
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
              } else if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // builder: (context) => const MedicineSearchPage(),
                    builder: (context) => const SearchPage(),
                  ),
                );
              } else if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MyOrdersPage();
                    },
                  ),
                );
              } else if (index == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.home,
                ),
                activeIcon: Image(
                  image: AssetImage(
                    ImageConstants.home,
                  ),
                  height: 30,
                  width: 30,
                  color: ColorConstants.darkblue,
                ),
                label: '',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                ),
                label: '',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_cart,
                ),
                label: '',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                ),
                label: '',
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Form(
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: 'Search...',
                                    border: InputBorder.none,
                                    icon: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Icon(Icons.search),
                                    ),
                                  ),
                                  onFieldSubmitted: (value) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MedicalStoreListScreen(
                                                searchQuery: value),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: IconButton(
                            iconSize: 30,
                            icon: const Icon(Icons.camera_alt),
                            onPressed: () {
                              //sendWhatsAppMessage();
                              pickDescriptionImage(context);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: IconButton(
                            iconSize: 30,
                            icon: const Icon(Icons.share),
                            onPressed: () {
                              isInstalled();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: screenWidth * (9 / 16),
                    width: screenWidth,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          itemCount: widget.imagePaths.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  _showImageDescription(context, index);
                                },
                                // ignore: sized_box_for_whitespace
                                child: Container(
                                  width: screenWidth,
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Image.asset(
                                      widget.imagePaths[index],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ));
                          },
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Recommended for you",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Use GridView.count for the row of cells
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.count(
                      crossAxisCount: 3, // Number of cells in a row
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      shrinkWrap: true,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MedicineDetailsPage(
                                  medicineDetails: MedicineDetails(
                                    medicineName: 'Paracetamol',
                                    dosage: '650mg',
                                    tablets: 'Strip of 15 tablets',
                                    description:
                                        'Dolo 650 tablet contains an active ingredient called paracetamol, which works by blocking the '
                                        'formation of certain chemicals that cause pain and fever in the body. This medicine can'
                                        ' be used to treat various conditions such as headache, backache, migraine, toothache, body pain, '
                                        'and even fever associated with diseases like typhoid or the common cold.',
                                    shippingMethod: 'Standard Shipping',
                                    cost: '29/-',
                                    imagePaths: [
                                      'assets/images/tablets/paracetemol1.png',
                                      'assets/images/tablets/paracetemol2.webp'
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                // height: 90, // Set the desired height here
                                height: 85, // Set the desired height here
                                child: Image.asset(
                                  "assets/images/tablets/paracetemol1.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Text("Paracetamol"),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MedicineDetailsPage(
                                  medicineDetails: MedicineDetails(
                                    medicineName: 'Cetirizine',
                                    dosage: 'As directed by Physician',
                                    tablets: ' syrup of 60ml',
                                    description:
                                        'Syrup which is used o reduce to common cold, Allergy, Urticaria Pigmentosa ',
                                    shippingMethod: 'Standard shipping',
                                    cost: '85/-',
                                    imagePaths: [
                                      'assets/images/tablets/Cetirizine1.png',
                                      'assets/images/tablets/Cetirizine2.png',
                                      'assets/images/tablets/Cetirizine3.png',
                                      // Add more image paths if needed
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                // height: 90, // Set the desired height here
                                height:
                                    85, // Set the desired height here // Set the desired height here
                                child: Image.asset(
                                  "assets/images/tablets/cetrizine.webp",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Text("Cetirizine"),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MedicineDetailsPage(
                                  medicineDetails: MedicineDetails(
                                    medicineName: 'Saridon',
                                    dosage:
                                        'single dose can be taken at a time ',
                                    tablets: 'Strip of 10 tablets ',
                                    description:
                                        'Saridon Tablet, a prescription drug, is manufactured in various forms such as Tablet.'
                                        ' Fever, Headache, Pain are some of its major therapeutic uses.'
                                        ' Other than this, Saridon Tablet has some other therapeutic uses,',
                                    shippingMethod: 'Standard shipping',
                                    cost: '40/-',
                                    imagePaths: [
                                      'assets/images/tablets/saridon.webp',
                                      'assets/images/tablets/saridon1.jpg',
                                      // Add more image paths if needed
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                // height: 90, // Set the desired height here
                                height:
                                    85, // Set the desired height here // Set the desired height here
                                child: Image.asset(
                                  "assets/images/tablets/saridon.webp",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Text("Saridon"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.count(
                      crossAxisCount: 3, // Number of cells in a row
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      shrinkWrap: true,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MedicineDetailsPage(
                                  medicineDetails: MedicineDetails(
                                    medicineName: 'Spirulina',
                                    dosage: '650mg',
                                    tablets: '120 tablets of 500mg',
                                    description:
                                        'Rich in Iron to improve your Haemoglobin levels, Protein for better heart health, Vitamin K for bone health'
                                        '.',
                                    shippingMethod: 'Standard Shipping',
                                    cost: '315/-',
                                    imagePaths: [
                                      'assets/images/tablets/spirulina.jpg',
                                      'assets/images/tablets/spirulina1.jpg'
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                // height: 90, // Set the desired height here
                                height:
                                    85, // Set the desired height here // Set the desired height here
                                child: Image.asset(
                                  "assets/images/tablets/spirulina.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Text("Spirulina"),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MedicineDetailsPage(
                                  medicineDetails: MedicineDetails(
                                    medicineName: 'Vitamin C tablets',
                                    dosage: '75 mg per day for adults',
                                    tablets: ' 1400mg ',
                                    description:
                                        'PURE NUTRITION CALCIUM consists of calcium citrate malate with added essential vitamins, minerals, and natural '
                                        'extracts each having unique ways to support bone and muscle health ',
                                    shippingMethod: 'Standard shipping',
                                    cost: '400/-',
                                    imagePaths: [
                                      'assets/images/tablets/vitamin c.webp',
                                      'assets/images/tablets/vitamin c2.jfif'
                                      // Add more image paths if needed
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                // height: 70, // Set the desired height here
                                height: 65, // Set the desired height here
                                child: Image.asset(
                                  "assets/images/tablets/vitamin c.webp",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Text("Vitamin C\n tablets"),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MedicineDetailsPage(
                                  medicineDetails: MedicineDetails(
                                    medicineName: 'Solvin Cough Tablets',
                                    dosage:
                                        'single dose can be taken at a time ',
                                    tablets: 'Strip of 10 tablets ',
                                    description:
                                        'This medicine is used as medication for cold and cough preparations',
                                    shippingMethod: 'Standard shipping',
                                    cost: '63/-',
                                    imagePaths: [
                                      'assets/images/tablets/cough1.webp',
                                      'assets/images/tablets/solvin1.webp',
                                      // Add more image paths if needed
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                // height: 90, // Set the desired height here
                                height:
                                    85, // Set the desired height here // Set the desired height here
                                child: Image.asset(
                                  "assets/images/tablets/solvin1.webp",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Text("Solvin tablet"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Pharmacies Recommended for you",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: pharmacyData.length,
                        itemBuilder: (context, index) {
                          final data = pharmacyData[index];
                          final name = data["name"] ?? "N/A";
                          final tel = data["tel"] ?? "N/A";
                          final formattedAddress =
                              data["location"]["formatted_address"] ?? "N/A";

                          return Card(
                            child: ListTile(
                              title: Text(name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Phone Number: $tel"),
                                  Text("Address: $formattedAddress"),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetchMedicalStores() async {
    const url =
        "https://api.foursquare.com/v3/places/search?query=pharmacy&ll=13.6447653%2C79.4175508&radius=5000&fields=name%2Clocation%2Ctel%2Cemail%2Cwebsite%2Chours&sort=RELEVANCE&limit=30";

    final headers = {
      "accept": "application/json",
      "Authorization": "fsq3LPvbSdx96rSXZgsqmzDM3f/3KxqosKh/xuQZ2WT3MU8="
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final results = responseData["results"];

        final validMedicalStores = List<Map<String, dynamic>>.from(results)
            .where((store) =>
                store["tel"] != null &&
                store["tel"] != "N/A" &&
                store["location"]["formatted_address"] != null &&
                store["location"]["formatted_address"] != "N/A")
            .toList();

        setState(() {
          pharmacyData = validMedicalStores;
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
