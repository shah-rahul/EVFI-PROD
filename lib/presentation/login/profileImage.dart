import 'package:evfi/presentation/login/profileUpload.dart';
import 'package:evfi/presentation/onboarding/onboarding.dart';
import 'package:evfi/presentation/resources/assets_manager.dart';
import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:flutter/material.dart';
import '../resources/font_manager.dart';
import '../resources/strings_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ProfileImage extends StatelessWidget {
  Future<void> _getImage(BuildContext context) async {
    XFile? imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      File compressedImage = await compressImage(File(imageFile.path));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileUpload(imagePath: compressedImage.path),
        ),
      );
    }
  }

  Future<File> compressImage(File imageFile) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = DateTime.now().millisecondsSinceEpoch;

    Uint8List? result = await FlutterImageCompress.compressWithFile(
      imageFile.path,
      minWidth: 1024,
      minHeight: 1024,
      quality: 85,
      format: CompressFormat.jpeg
    );
    File compressedImage = File('$path/img_$rand.jpg')..writeAsBytesSync(result!);
    return compressedImage;
  }

  const ProfileImage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: ColorManager.appBlack,
        body: GestureDetector(
        onTap: () => _getImage(context),
          child: Center(
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: screenHeight * 0.08,
                  left: screenWidth * 0.05,
                  child: SizedBox(
                    height: screenHeight * 0.064,
                    width: screenHeight * 0.064,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primary,
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.chevron_left,
                              size: screenWidth * 0.05,
                              color: ColorManager.appBlack,
                            ),
                          ],
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
                  top: screenHeight * 0.62,
                  left: screenWidth * 0.14,
                  child: Text(
                    AppStrings.tap,
                    style: TextStyle(
                      color: ColorManager.primary,
                      fontSize: FontSize.s32,
                      fontFamily: FontConstants.appTitleFontFamily,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      shadows: <Shadow>[
                        Shadow(
                            offset: const Offset(2.0, 2.0),
                            color: ColorManager.primary20),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.66,
                  left: screenWidth * 0.13,
                  child: Text(
                    AppStrings.uploadAnImage,
                    style: TextStyle(
                      color: ColorManager.primary,
                      fontSize: FontSize.s32,
                      fontFamily: FontConstants.appTitleFontFamily,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      shadows: <Shadow>[
                        Shadow(
                            offset: const Offset(2.0, 2.0),
                            color: ColorManager.primary20),
                      ],
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
                          MaterialPageRoute(
                              builder: (context) => const OnBoardingView()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.02),
                        ),
                        // primary: ColorManager.primary,
                      ),
                      child: Text(
                        AppStrings.skipForLater,
                        style: TextStyle(
                            color: ColorManager.appBlack,
                            fontFamily: FontConstants.appTitleFontFamily,
                            fontWeight: FontWeight.bold,
                            fontSize: FontSize.s26),
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