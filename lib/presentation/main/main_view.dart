// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../resources/color_manager.dart';

import '../pages/screens/1homePage/home.dart';
import '../pages/screens/4accountPage/account.dart';
import '../pages/screens/2Bookings/BookingsScreen.dart';
import '../pages/screens/3Chargings/MyChargingScreen.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentScreen = 0;

  final List<Widget> screens = const [
    Home(),
    BookingsScreen(),
    MyChargingScreen(),
    Account(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: DotNavigationBar(
        currentIndex: _currentScreen,
        //margin: EdgeInsets.symmetric(horizontal: 10.0),
        marginR: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        borderRadius: 20,
        paddingR: const EdgeInsets.all(5),
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
            //home screen
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
            //label: 'Bookings on my charger screen',
          ),
          DotNavigationBarItem(
            icon: Image.asset(
              'assets/images/navbar_icons/account_icon.png',
              height: 32,
              color: _currentScreen == 3
                  ? ColorManager.primary
                  : ColorManager.lightGrey,
            ),
            //label: 'Account/Profile section',
          ),
        ],
      ),
      // body: IndexedStack(
      //   index: _currentScreen,
      //   children: screens
      // const [
      //   Home(),
      //   BookingsScreen(),
      //   MyChargingScreen(),
      //   Account(),
      // ],
      // ),
      body: screens.elementAt(_currentScreen),
    );
  }
}
