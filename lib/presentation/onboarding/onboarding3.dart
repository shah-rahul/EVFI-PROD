// import 'package:evfi_duplicate/onboarding2.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../register/vehicleform.dart';
import 'onboarding2.dart';

class Onboarding3 extends StatelessWidget {
  final Color myColor = Color.fromRGBO(208, 187, 30, 0.5);
  final Color myColor2 = Color.fromRGBO(99, 99, 95, 1);
  final Color mainColor = Color.fromRGBO(255, 216, 15, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            // First picture (at the bottom)
            Positioned(
              top: 100, // Adjust the position as needed
              left: 95, // Adjust the position as needed
              child: Image.asset(
                'assets/assetss/plugged_car.png', // Path to your first picture
                width: 300, // Set the width of the first picture
                height: 300, // Set the height of the first picture
              ),
            ),
            // Second picture (overlapping the first picture)
            Positioned(
              top: 440, // Adjust the position as needed
              left: 100,
              child: Text(
                'get best path',
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 28,
                  fontFamily: 'fonts/Poppins',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  shadows: <Shadow>[
                    Shadow(offset: Offset(-4.0, 3.0), color: myColor),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 470, // Adjust the position as needed
              left: 40,
              child: Text(
                'to your destinantion',
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 28,
                  fontFamily: 'fonts/Poppins',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  shadows: <Shadow>[
                    Shadow(offset: Offset(-4.0, 3.0), color: myColor),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 650, // Adjust the position as needed
              left: 20,
              child: SizedBox(
                height: 60,
                width: 60,
                child: SingleChildScrollView(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Onboarding2()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black, // Button background color
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.chevron_left,
                          size: 28,
                          color: mainColor,
                        ), // Your icon here
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 650, // Adjust the position as needed
              left: 150, // Adjust the position as needed
              child: Image.asset(
                'assets/assetss/right.png', // Path to your first picture
                width: 100, // Set the width of the first picture
                height: 50, // Set the height of the first picture
              ),
            ),
            Positioned(
              top: 650, // Adjust the position as needed
              left: 330,
              child: SizedBox(
                height: 60,
                width: 60,
                child: SingleChildScrollView(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: VehicleForm()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black, // Button background color
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.chevron_right,
                            size: 28, color: mainColor), // Your icon here
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
