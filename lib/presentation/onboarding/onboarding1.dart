import 'package:flutter/material.dart';
import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:page_transition/page_transition.dart';
import '../register/vehicleform.dart';
import 'package:evfi/presentation/resources/assets_manager.dart';
import '../resources/font_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import '../resources/routes_manager.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColorManager.appBlack,
      body: Center(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: screenHeight * 0.08,
              left: screenWidth * 0.1,
              child: Image.asset(
                ImageAssets.car,
                width: screenWidth * 0.8,
                height: screenHeight * 0.5,
              ),
            ),
            Positioned(
              top: screenHeight * 0.55,
              left: screenWidth * 0.25,
              child: Text(
                AppStrings.onboardingTitle1,
                style: TextStyle(
                  color: ColorManager.primary,
                  fontSize: FontSize.s28,
                  fontFamily: 'fonts/Poppins',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  shadows: <Shadow>[
                    Shadow(
                        offset: const Offset(-4.0, 3.0),
                        color: ColorManager.dullYellow
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.60,
              left:screenWidth * 0.03,
              child: Text(
                AppStrings.onboardingSubTitle1,
                style: TextStyle(
                  color: ColorManager.primary,
                  fontSize: FontSize.s28,
                  fontFamily: 'fonts/Poppins',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  shadows: <Shadow>[
                    Shadow(
                        offset: const Offset(-4.0, 3.0),
                        color: ColorManager.dullYellow
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.90,
              left: screenWidth * 0.02,
              child: SizedBox(
                height: screenHeight * 0.07,
                width: screenWidth * 0.2,
                child: SingleChildScrollView(
                  child: ElevatedButton(
                    onPressed: () {
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.appBlack,
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.chevron_left,size: screenWidth * 0.08,color: ColorManager.primary),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.89,
              left: screenWidth * 0.43,
              child: Image.asset(
                ImageAssets.left,
                width: screenWidth * 0.15,
                height: screenHeight * 0.08,
              ),
            ),
            Positioned(
              top: screenHeight * 0.90,
              left: screenWidth * 0.80,
              child: SizedBox(
                height: screenHeight * 0.07,
                width: screenWidth * 0.2,
                child: SingleChildScrollView(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Onboarding2()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.appBlack,
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.chevron_right,size: screenWidth * 0.08,color: ColorManager.primary),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColorManager.appBlack,
      body: Center(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: screenHeight * 0.10,
              left: screenWidth * 0.1,
              child: Image.asset(
                ImageAssets.station,
                width: screenWidth * 0.8,
                height: screenHeight * 0.4,
              ),
            ),
            Positioned(
              top: screenHeight * 0.60,
              left: screenWidth * 0.15,
              child: Text(
                AppStrings.onboardingTitle3,
                style: TextStyle(
                  color: ColorManager.primary,
                  fontSize: FontSize.s28,
                  fontFamily: 'fonts/Poppins',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  shadows: <Shadow>[
                    Shadow(
                        offset: const Offset(-4.0, 3.0),
                        color: ColorManager.dullYellow
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.65,
              left:screenWidth * 0.03,
              child: Text(
                AppStrings.onboardingSubTitle3,
                style: TextStyle(
                  color: ColorManager.primary,
                  fontSize: FontSize.s28,
                  fontFamily: 'fonts/Poppins',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  shadows: <Shadow>[
                    Shadow(
                        offset: const Offset(-4.0, 3.0),
                        color: ColorManager.dullYellow
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.90,
              left: screenWidth * 0.02,
              child: SizedBox(
                height: screenHeight * 0.07,
                width: screenWidth * 0.2,
                child: SingleChildScrollView(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Onboarding1()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.appBlack,
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.chevron_left,size: screenWidth * 0.08,color: ColorManager.primary),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.89,
              left: screenWidth * 0.43,
              child: Image.asset(
                ImageAssets.middle,
                width: screenWidth * 0.15,
                height: screenHeight * 0.08,
              ),
            ),
            Positioned(
              top: screenHeight * 0.90,
              left: screenWidth * 0.80,
              child: SizedBox(
                height: screenHeight * 0.07,
                width: screenWidth * 0.2,
                child: SingleChildScrollView(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Onboarding3()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.appBlack,
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.chevron_right,size: screenWidth * 0.08,color: ColorManager.primary),
                      ],
                    ),
                  ),
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Onboarding3 extends StatelessWidget {
  const Onboarding3({super.key});


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColorManager.appBlack,
      body: Center(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: screenHeight * 0.10,
              left: screenWidth * 0.18,
              child: Image.asset(
                ImageAssets.pluggedCar,
                width: screenWidth * 0.8,
                height: screenHeight * 0.4,
              ),
            ),
            Positioned(
              top: screenHeight * 0.60,
              left: screenWidth * 0.25,
              child: Text(
                AppStrings.onboardingTitle2,
                style: TextStyle(
                  color: ColorManager.primary,
                  fontSize: FontSize.s28,
                  fontFamily: 'fonts/Poppins',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  shadows: <Shadow>[
                    Shadow(offset: const Offset(-4.0, 3.0), color: ColorManager.dullYellow),
                  ],
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.65,
              left:screenWidth * 0.13,
              child: Text(
                AppStrings.onboardingSubTitle2,
                style: TextStyle(
                  color: ColorManager.primary,
                  fontSize: FontSize.s28,
                  fontFamily: 'fonts/Poppins',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  shadows: <Shadow>[
                    Shadow(offset: const Offset(-4.0, 3.0), color: ColorManager.dullYellow),
                  ],
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.90,
              left: screenWidth * 0.02,
              child: SizedBox(
                height: screenHeight * 0.07,
                width: screenWidth * 0.2,
                child: SingleChildScrollView(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Onboarding2()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.appBlack,
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.chevron_left,
                          size: screenWidth * 0.08,
                          color: ColorManager.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.89,
              left: screenWidth * 0.43,
              child: Image.asset(
                ImageAssets.right, //
                width: screenWidth * 0.15, //
                height: screenHeight * 0.08, //
              ),
            ),
            Positioned(
              top: screenHeight * 0.90, //
              left: screenWidth * 0.80,
              child: SizedBox(
                height: screenHeight * 0.07,
                width: screenWidth * 0.2,
                child: SingleChildScrollView(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: const VehicleForm()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.appBlack,
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.chevron_right,
                            size: screenWidth * 0.08, color: ColorManager.primary),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
