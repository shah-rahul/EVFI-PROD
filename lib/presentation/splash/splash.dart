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
    return Scaffold(
      backgroundColor: ColorManager.appBlack,
      body: const Center(
        child: Image(
          image: AssetImage(ImageAssets.splashlogo),
          width: 250,
          height: 250,
        ),
      ),
    );
  }

  void whereToGo() async {
    var sharedPref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedPref.getBool(keyLogin);
    //var isLoggedIn=
    Timer(
      const Duration(seconds: 2),
      () {
        if (isLoggedIn != null) {
          if (isLoggedIn) {
            Navigator.pushReplacementNamed(
                context, /*Routes.onBoardingRoute*/ Routes.mainRoute);
          } else {
            Navigator.pushReplacementNamed(
                context, /*Routes.onBoardingRoute*/ Routes.loginRoute);
          }
        } else {
          Navigator.pushReplacementNamed(
              context, /*Routes.onBoardingRoute*/ Routes.loginRoute);
        }
      },
    );
  }
}
