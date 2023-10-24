import 'package:evfi/presentation/login/profileUpload.dart';
import 'package:evfi/presentation/login/verify.dart';
import 'package:evfi/presentation/resources/assets_manager.dart';
import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../resources/font_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import '../resources/routes_manager.dart';

import 'name.dart';
class ProfileImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColorManager.appBlack,
      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileUpload()),
          );
        },
        child: Center(
          child: Stack(
            children: <Widget>[
              Positioned(
                top: screenHeight * 0.08,
                left: screenWidth * 0.05,
                child: SizedBox(
                  height: screenHeight * 0.12,
                  width: screenWidth * 0.12,
                  child: SingleChildScrollView(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                        PageTransition(
                                type: PageTransitionType.rightToLeft,
                                // child: VerificationCodePage(
                                //   verificationId: verificationId,
                                //   phoneNumber: phoneNumber,
                                // ),
                              child: Verify(phoneNumber: '', verificationId: '',
                              
                              ),


                              ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: ColorManager.primary,
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.chevron_left,size: screenWidth * 0.03,color: ColorManager.appBlack,),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.18,
                left: screenWidth * 0.10,
                child: Image.asset(
                  ImageAssets.arrow,
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.2,
                ),
              ),
              Positioned(
                top: screenHeight * 0.28,
                left: screenWidth * 0.20,
                child: Image.asset(
                  ImageAssets.rectangle,
                  width: screenWidth * 0.6,
                  height: screenWidth * 0.6,
                ),
              ),
                Positioned(
                  top: screenHeight * 0.59,
                  left: screenWidth * 0.17,
                  child: Text(
                    AppStrings.tap,
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
                top: screenHeight * 0.63,
                left: screenWidth * 0.17,
                child: Text(
                  AppStrings.uploadAnImage,
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
                      AppStrings.skipForLater,
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
      )
    );
  }
}