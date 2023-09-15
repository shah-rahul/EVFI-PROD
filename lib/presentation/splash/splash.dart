import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/routes_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  SplashViewState createState() => SplashViewState();
}

class SplashViewState extends State<SplashView> {
  Timer? _timer;
  static const String keyLogin = "login";
  @override
  void initState() {
    super.initState();
    // _startDelay();
    whereToGo();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: ColorManager.appBlack,
        body: Align(
          alignment: Alignment.center,
          child: Container(
            width: width * 0.3,
            child: Image.asset(
              ImageAssets.splashlogo,
              fit: BoxFit.cover,
            ),
          ),
        ));
  }

  void whereToGo() async {
    var sharedPref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedPref.getBool(keyLogin);
    Timer(
      const Duration(seconds: 2),
      () {
        if (isLoggedIn != null) {
          if (isLoggedIn) {
            Navigator.pushReplacementNamed(
                context, /*Routes.onBoardingRoute*/ Routes.mainRoute);
          } else {
            Navigator.pushReplacementNamed(
                context, /*Routes.onBoardingRoute*/ Routes.mainRoute);
          }
        } else {
          Navigator.pushReplacementNamed(
              context, /*Routes.onBoardingRoute*/ Routes.mainRoute);
        }
      },
    );
  }
}
