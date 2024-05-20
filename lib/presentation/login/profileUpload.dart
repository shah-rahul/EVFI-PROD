import 'package:evfi/presentation/login/profileImage.dart';
import 'package:evfi/presentation/onboarding/onboarding.dart';
import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:evfi/presentation/resources/assets_manager.dart';
import '../resources/font_manager.dart';
import '../resources/strings_manager.dart';
import 'dart:io';

class ProfileUpload extends StatefulWidget {
  @override
  State<ProfileUpload> createState() => _ProfileUploadState();
  final String imagePath;

  const ProfileUpload({required this.imagePath});
}

class _ProfileUploadState extends State<ProfileUpload> {
  double _scale = 1.0;
  double _previousScale = 1.0;
  Offset _offset = Offset.zero;
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
                    height: screenHeight * 0.064,
                    width: screenHeight * 0.064,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfileImage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primary,
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.chevron_left,size: screenWidth * 0.05,color: ColorManager.appBlack),
                          ],
                        ),
                      ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.15,
                  left: screenWidth * 0.16,
                  child: Image.asset(
                    ImageAssets.circle,
                    width: screenWidth * 0.7,
                    height: screenWidth * 0.7,
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.185,
                  left: screenWidth * 0.235,
                  child: GestureDetector(
                    onScaleStart: (ScaleStartDetails details) {
                      _previousScale = _scale;
                    },
                    onScaleUpdate: (ScaleUpdateDetails details) {
                      setState(() {
                        _scale = (_previousScale * details.scale).clamp(1.0, 3.0);
                        _offset = details.focalPoint - Offset(screenWidth * 0.20, screenHeight * 0.20);
                      });
                    },
                    child: ClipOval(
                      child: Container(
                        width: screenWidth * 0.55,
                        height: screenWidth * 0.55,
                        child: InteractiveViewer(
                          minScale: 1.0,
                          maxScale: 3.0,
                          constrained: true,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image.file(
                              File(widget.imagePath),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.62,
                  left: screenWidth * 0.18,
                  child: Text(
                    AppStrings.lookingClean,
                    style: TextStyle(
                      color: ColorManager.primary,
                      fontSize: FontSize.s32,
                      fontFamily: FontConstants.appTitleFontFamily,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),

                Positioned(
                  top: screenHeight * 0.85,
                  left: screenWidth * 0.11,
                  child: SizedBox(
                    height: screenHeight * 0.065,
                    width: screenWidth * 0.77,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OnBoardingView()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        ),
                      ),
                      child: Text(
                        AppStrings.upload,
                        style: TextStyle(
                            color: ColorManager.appBlack,
                            fontFamily: FontConstants.appTitleFontFamily,
                            fontWeight: FontWeight.bold,
                            fontSize: FontSize.s26
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
