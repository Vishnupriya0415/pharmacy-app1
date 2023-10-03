import 'package:gangaaramtech/SignUpScreen/SIgnUPScreen.dart';
//import 'package:gangaaramtech/pages/authentication/siginin/signin.dart';
import 'package:gangaaramtech/utils/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:gangaaramtech/utils/constants/font_constants.dart';
import 'package:gangaaramtech/utils/constants/image_constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);
  static Page page() => const MaterialPage<void>(child: OnboardingScreen());

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    setState(() {
      _currentPage = _pageController.page!.toInt();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < data.length - 1) {
      _pageController.nextPage(
        curve: Curves.ease,
        duration: const Duration(milliseconds: 300),
      );
    } else {
      loginPageNav(context);
    }
  }

  void _skipToLogin() {
    loginPageNav(context);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double screenWidth = constraints.maxWidth;
        // final double screenHeight = constraints.maxHeight;
        // final double paddingVertical = screenHeight * 0.01;
        final double paddingHorizontal = screenWidth * 0.05;
        final double titleFontSize = screenWidth * 0.06;

        return Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(
              left: 40,
              right: 38,
              bottom: 62,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _skipToLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: Text(
                    "Skip",
                    style: FontConstants.lightVioletMixedGreyNormal14,
                  ),
                ),
                CustomSmoothIndicator(
                  controller: _pageController,
                  count: data.length,
                ),
                ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: Text(
                    _currentPage < data.length - 1 ? 'Next' : 'Next',
                    style: FontConstants.blueNormal14,
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: ColorConstants.white,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    itemCount: data.length,
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) => OnboardingContent(
                      image: data[index].image,
                      title: data[index].title,
                      description: data[index].description,
                      paddingHorizontal: paddingHorizontal,
                      titleFontSize: titleFontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomSmoothIndicator extends StatelessWidget {
  final PageController controller;
  final int count;

  const CustomSmoothIndicator(
      {super.key, required this.controller, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      margin: const EdgeInsets.only(
        top: 11,
        bottom: 7,
      ),
      child: SmoothPageIndicator(
        controller: controller,
        count: count,
        effect: WormEffect(
          dotHeight: 4,
          dotWidth: 4,
          activeDotColor: ColorConstants.darkblue,
          dotColor: ColorConstants.grey,
          strokeWidth: 1.5,
          spacing: 8,
        ),
      ),
    );
  }
}

loginPageNav(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const SignUpScreen(),
    ),
  );
}

class Onboard {
  final String image, title, description;

  Onboard({
    required this.image,
    required this.title,
    required this.description,
  });
}

final List<Onboard> data = [
  Onboard(
    image: ImageConstants.onboard1,
    title: 'View & buy Medicine online',
    description:
        'Choose and buy the necessary drugs without a visit to the pharmacy',
  ),
  Onboard(
    image: ImageConstants.onboard2,
    title: 'Online medical',
    description: 'Access to wide Variety of prescribed medicines.',
  ),
  Onboard(
    image: ImageConstants.onboard3,
    title: 'Get Delivery on time',
    description: 'We will deliver your medicines quickly.',
  ),
];

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
    required this.paddingHorizontal,
    required this.titleFontSize,
  }) : super(key: key);

  final String image, title, description;
  final double paddingHorizontal;
  final double titleFontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.only(
        left: 59,
        right: 59,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            child: Image.asset(
              image,
              height: 284,
              width: 256,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 49),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: FontConstants.lightVioletNormal24,
            ),
          ),
          Container(
            width: 240,
            margin: const EdgeInsets.only(
              left: 8,
              top: 17,
              right: 8,
            ),
            child: Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: FontConstants.lightVioletMixedGreyNormal16,
            ),
          ),
        ],
      ),
    );
  }
}
