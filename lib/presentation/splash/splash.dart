import 'dart:async';

import 'package:flutter/material.dart';

import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/routes_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;

  _startDelay() {
    _timer = Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacementNamed(
            context, /*Routes.onBoardingRoute*/ Routes.loginRoute));
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
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
      body: Center(
        child: Image(
          image: AssetImage(ImageAssets.splashlogo),
          width: 250,
          height: 250,
        ),
      ),
    );
  }
}
