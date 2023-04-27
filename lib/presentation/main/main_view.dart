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
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(left: 24, right: 24, bottom: 12),
        decoration: BoxDecoration(
          color: ColorManager.appBlack,
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentScreen,
          type: BottomNavigationBarType.fixed,
          backgroundColor: ColorManager.appBlack,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.amberAccent,
          unselectedItemColor: Colors.white,
          onTap: (value) => setState(() {
            _currentScreen = value;
          }),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/navbar_icons/home_outlined.png',
                height: 30,
                color: _currentScreen == 0
                    ? ColorManager.primary
                    : ColorManager.lightGrey,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/navbar_icons/chargeStation.png',
                height: 30,
                color: _currentScreen == 1
                    ? ColorManager.primary
                    : ColorManager.lightGrey,
              ),
              label: 'Charge Station',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/navbar_icons/bookings_icon.png',
                height: 30,
                color: _currentScreen == 2
                    ? ColorManager.primary
                    : ColorManager.lightGrey,
              ),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/navbar_icons/account_icon.png',
                height: 32,
                color: _currentScreen == 3
                    ? ColorManager.primary
                    : ColorManager.lightGrey,
              ),
              label: 'Account',
            ),
          ],

          /*
            iconSize: 30,
            selectedItemColor: Colors.amberAccent,
            unselectedItemColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.thunderstorm_outlined),
                label: 'Bookings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.charging_station_outlined),
                label: 'EVSE',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outlined),//Image.asset('assets/images/account.jpg'),
                label: 'Profile',
              ),
            ],*/
        ),
      ),
      body: screens.elementAt(_currentScreen),
    );
  }
}
