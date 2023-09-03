// ignore_for_file: avoid_print, use_build_context_synchronously
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/pages/medicine_details_page/medicine_details_page.dart';
import 'package:gangaaramtech/pages/order_details/order_details.dart';
// import 'package:gangaaramtech/pages/search/search_page.dart';
import 'package:gangaaramtech/pages/search/search_page1.dart';
import 'package:gangaaramtech/pages/search_result_page/search_result_page.dart';
import 'package:gangaaramtech/pages/settings/settings.dart';
import 'package:gangaaramtech/utils/constants/color_constants.dart';
import 'package:gangaaramtech/utils/constants/image_constants.dart';
import 'package:gangaaramtech/utils/widgets/curved_alert_dialog_box.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  Home({super.key});
  final List<String> imagePaths = [
    'assets/images/tablets/delvery medicine3.jpg',
    'assets/images/tablets/delivery medicine2.jpg',
    'assets/images/tablets/delivery medicine1.png',
    // Add more image paths as needed
  ];

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startLocationUpdateTimer();
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

  Future<void> pickProfileImage(BuildContext context) async {
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
                    builder: (context) => const MyOrdersPage(),
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
        body: Container(
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
                                          const MedicalStoreListScreen(),
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
                            pickProfileImage(context);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const ImageUploadScreen(),
                            //   ),
                            // );
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
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.imagePaths.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: screenWidth,
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.asset(
                                widget.imagePaths[index],
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                  dosage: 'single dose can be taken at a time ',
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
                                  dosage: 'single dose can be taken at a time ',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
