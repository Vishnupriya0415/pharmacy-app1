import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gangaaramtech/Vendor/Order_provider.dart';
import 'package:gangaaramtech/Vendor/VHome/VendorHome.dart';
import 'package:gangaaramtech/Vendor/authentication/Vauth.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/SelectedDataProvider.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/providers/Order_placement.dart';
import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/providers/order_data.dart';
import 'package:gangaaramtech/pages/cart/CartProvider.dart';
//import 'package:gangaaramtech/pages/MyOrdersPage/OrderTracking/selected_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gangaaramtech/pages/common/onboardingscreen.dart';
import 'package:gangaaramtech/pages/home/home.dart';
import 'package:gangaaramtech/repository/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  // runApp(const MyApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_)=> VAuth()),
        ChangeNotifierProvider(create: (_) => OrderPlacementProvider()),
        ChangeNotifierProvider(create: (_) => OrderDataProvider()),
        ChangeNotifierProvider(
          create: (context) => SelectedDataProvider(),
        ),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        //ChangeNotifierProvider(create: (_) => ItemsInCartProvider())
        
        // Add other providers here
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return MaterialApp(
      title: 'Medical App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      supportedLocales: const [
        Locale('en'),
      ],
      localizationsDelegates: const [
        CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return FutureBuilder<String?>(
                future: getUserType(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final userType = snapshot.data;
                  if (userType != null) {
                    if (userType == 'medicalshop') {
                      return Home();
                    }
                    else if(userType == 'vendors'){
                      return const VendorHome();
                    }
                    // else if (userType == 'manager') {
                    //   // return const AutoLoginBoardScreen();
                    // } else if (userType == 'deliveryperson') {
                    //   // return const AutoLoginBoardScreen();
                    // } else if (userType == 'users') {
                    //   // return const AutoLoginBoardScreen();
                    // }
                  }
                  return const OnboardingScreen();
                },
              );
            }
          }
          return const OnboardingScreen();
        },
      ),
    );
  }

  Future<String?> getUserType() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('userType');
  }
}
