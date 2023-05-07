import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../resources/color_manager.dart';

import '../pages/home.dart';
import '../pages/account.dart';
import '../pages/chargeStation.dart';
import '../pages/bookings.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentScreen = 0;

  final List<Widget> screens = [
    Home(),
    ChargeStation(),
    Bookings(),
    Account(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
        child: DotNavigationBar(
          currentIndex: _currentScreen,
          //margin: EdgeInsets.symmetric(horizontal: 10.0),
          marginR: EdgeInsets.all(25),
          backgroundColor: ColorManager.appBlack,
          dotIndicatorColor: ColorManager.appBlack,
          onTap: (value) => setState(() {
            _currentScreen = value;
          }),
          items: <DotNavigationBarItem>[
            DotNavigationBarItem(
              icon: Image.asset(
                'assets/images/navbar_icons/home_outlined.png',
                height: 24,
                color: _currentScreen == 0
                    ? ColorManager.primary
                    : ColorManager.lightGrey,
              ),
            ),
            DotNavigationBarItem(
              icon: Image.asset(
                'assets/images/navbar_icons/chargeStation.png',
                height: 24,
                color: _currentScreen == 1
                    ? ColorManager.primary
                    : ColorManager.lightGrey,
              ),
              //label: 'Charge Station',
            ),
            DotNavigationBarItem(
              icon: Image.asset(
                'assets/images/navbar_icons/bookings_icon.png',
                height: 24,
                color: _currentScreen == 2
                    ? ColorManager.primary
                    : ColorManager.lightGrey,
              ),
              //label: 'Bookings',
            ),
            DotNavigationBarItem(
              icon: Image.asset(
                'assets/images/navbar_icons/account_icon.png',
                height: 32,
                color: _currentScreen == 3
                    ? ColorManager.primary
                    : ColorManager.lightGrey,
              ),
              //label: 'Account',
            ),
          ],
        ),
      ),
      body: screens.elementAt(_currentScreen),
    );
  }
}
