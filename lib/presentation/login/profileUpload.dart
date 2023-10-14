// import 'package:evfi_duplicate/name.dart';
// import 'package:evfi_duplicate/profileImage.dart';
import 'package:evfi/presentation/login/profileImage.dart';
import 'package:flutter/material.dart';

import 'name.dart';
class ProfileUpload extends StatelessWidget {
  final Color myColor = Color.fromRGBO(208, 187, 30, 0.5);
  final Color myColor2 = Color.fromRGBO(99,99,95,1);
  final Color mainColor = Color.fromRGBO(255,216,15,1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: Stack(
              children: <Widget>[
                // First picture (at the bottom)
                Positioned(
                  top: 50, // Adjust the position as needed
                  left: 30,
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: SingleChildScrollView(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfileImage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: mainColor, // Button background color
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.chevron_left,size: 28,color: Colors.black,), // Your icon here
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 150, // Adjust the position as needed
                  left: 50, // Adjust the position as needed
                  child: Image.asset(
                    'assets/assetss/Circle.png', // Path to your first picture
                    width: 300, // Set the width of the first picture
                    height: 300, // Set the height of the first picture
                  ),
                ),
                // Second picture (overlapping the first picture)
                Positioned(
                  top: 540, // Adjust the position as needed
                  left: 100,
                  child: Text(
                    'looking clean',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 28,
                      fontFamily: 'fonts/Poppins',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      shadows: <Shadow>[
                        Shadow(
                            offset: Offset(-4.0, 3.0),
                            color: myColor
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 700, // Adjust the position as needed
                  left: 30,
                  child: SizedBox(
                    height: 50,
                    width: 330,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Name()),
                        );
                        // Add your login logic here
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0), // Set the border radius here
                        ),
                        primary: mainColor, // Button background color
                      ),
                      child: Text(
                        'upload',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 24
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