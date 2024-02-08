import 'package:evfi/presentation/login/profileImage.dart';
import 'package:evfi/presentation/onboarding/onboarding.dart';
import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:evfi/presentation/resources/assets_manager.dart';
import '../resources/font_manager.dart';
import '../resources/strings_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


import 'name.dart';
class ProfileUpload extends StatefulWidget {
  @override
  State<ProfileUpload> createState() => _ProfileUploadState();
}

class _ProfileUploadState extends State<ProfileUpload> {
  ImagePicker _imagePicker = ImagePicker();
  PickedFile? _pickedFile;
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
                  child: GestureDetector(
                    onScaleStart: (ScaleStartDetails details) {
                      _previousScale = _scale;
                    },
                    onScaleUpdate: (ScaleUpdateDetails details) {
                      setState(() {
                        _scale = (_previousScale * details.scale).clamp(1.0, 3.0);
                        _offset = details.focalPoint - Offset(screenWidth * 0.15, screenHeight * 0.15);
                      });
                    },
                    onTap: _pickImage,
                    child: ClipOval(
                      child: Transform.scale(
                        scale: _scale,
                        child: _pickedFile != null
                            ? CircleAvatar(
                          backgroundImage: FileImage(
                            File(_pickedFile!.path),
                          ),
                          radius: screenWidth * 0.35,
                        )
                            : Image.asset(
                          ImageAssets.circle, // Replace with your default profile image path
                          width: screenWidth * 0.7,
                          height: screenWidth * 0.7,
                        ),
                      ),
                    ),
                  ),
                ),

                // Positioned(
                //   top: screenHeight * 0.15,
                //   left: screenWidth * 0.15,
                //   width: screenWidth * 0.8,
                //   height: screenWidth * 0.8,
                //   child: GestureDetector(
                //     onScaleStart: (ScaleStartDetails details) {
                //       _previousScale = _scale;
                //     },
                //     onScaleUpdate: (ScaleUpdateDetails details) {
                //       setState(() {
                //         _scale = (_previousScale * details.scale).clamp(1.0, 3.0);
                //         _offset = details.focalPoint - Offset(screenWidth * 0.20, screenHeight * 0.20);
                //       });
                //     },
                //     onTap: _pickImage,
                //     child: ClipOval(
                //       child: Transform.scale(
                //         scale: _scale,
                //         child: _pickedFile != null
                //             ? Image.file(
                //           File(_pickedFile!.path),
                //           width: screenWidth * 0.7,
                //           height: screenWidth * 0.7,
                //           fit: BoxFit.cover,
                //         )
                //             : Image.asset(
                //           ImageAssets.circle,
                //           width: screenWidth * 0.7,
                //           height: screenWidth * 0.7,
                //           fit: BoxFit.cover,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Positioned(
                  top: screenHeight * 0.62,
                  left: screenWidth * 0.18,
                  child: Text(
                    AppStrings.lookingClean,
                    style: TextStyle(
                      color: ColorManager.primary,
                      fontSize: FontSize.s32,
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
                          MaterialPageRoute(builder: (context) => OnBoardingView()),
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
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _imagePicker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50
      );

      if (pickedFile != null) {
        setState(() {
          _pickedFile = pickedFile;
          _scale = 1.0; // Reset scale when a new image is picked
          _offset = Offset.zero; // Reset offset when a new image is picked
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }
}
