import 'package:evfi/presentation/login/profileImage.dart';
import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:evfi/presentation/resources/assets_manager.dart';
import '../resources/font_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import '../resources/routes_manager.dart';

import 'name.dart';
class ProfileUpload extends StatelessWidget {
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
                  left:screenWidth * 0.05,
                  child: SizedBox(
                    height: screenHeight * 0.12,
                    width: screenWidth * 0.12,
                    child: SingleChildScrollView(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfileImage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: ColorManager.primary,
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.chevron_left,size: screenWidth * 0.03,color: ColorManager.appBlack,), // Your icon here
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.15,
                  left: screenWidth * 0.15,
                  child: Image.asset(
                    ImageAssets.circle,
                    width: screenWidth * 0.7,
                    height: screenWidth * 0.7,
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.59,
                  left: screenWidth * 0.23,
                  child: Text(
                    AppStrings.lookingClean,
                    style: TextStyle(
                      color: ColorManager.primary,
                      fontSize: FontSize.s35,
                      fontFamily: 'fonts/Poppins',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      shadows: <Shadow>[
                        Shadow(
                            offset: Offset(-4.0, 3.0),
                            color: ColorManager.dullYellow
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.85,
                  left: screenWidth * 0.10,
                  child: SizedBox(
                    height: screenHeight * 0.06,
                    width: screenWidth * 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Name()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        ),
                        primary: ColorManager.primary,
                      ),
                      child: Text(
                        AppStrings.upload,
                        style: TextStyle(
                            color: ColorManager.appBlack,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: FontSize.s20
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