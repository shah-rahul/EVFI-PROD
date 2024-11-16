import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:evfi/presentation/onboarding/onboarding.dart';
import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:evfi/presentation/resources/strings_manager.dart';
import 'package:evfi/presentation/resources/font_manager.dart';
import 'package:evfi/presentation/resources/assets_manager.dart';

class ProfileUpload extends StatefulWidget {
  final String imagePath;

  const ProfileUpload({super.key, required this.imagePath});

  @override
  State<ProfileUpload> createState() => _ProfileUploadState();
}

class _ProfileUploadState extends State<ProfileUpload> {
  double _scale = 1.0;
  double _previousScale = 1.0;
  Offset _offset = Offset.zero;

  Future<void> uploadImage(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user signed in');
        return;
      }

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageRef = storage.ref().child('profile_images');
      String fileName = Path.basename(widget.imagePath);
      UploadTask uploadTask = storageRef.child(fileName).putFile(File(widget.imagePath));

      await uploadTask.whenComplete(() async {
        String imageUrl = await storageRef.child(fileName).getDownloadURL();
        print('Download URL: $imageUrl');

        // Update user profile with imageUrl in Firestore
        await updateUserImageUrl(imageUrl);

        // Navigate to the next screen (OnBoardingView in this case)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OnBoardingView()),
        );
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> updateUserImageUrl(String imageUrl) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user signed in');
        return;
      }

      // Assuming the users' collection is stored in Firestore
      // and each user document has a field 'imageUrl'
      await FirebaseFirestore.instance.collection('user').doc(user.uid).update({
        'imageUrl': imageUrl,
      });
    } catch (e) {
      print('Error updating user image URL in Firestore: $e');
    }
  }

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
                  child: Icon(Icons.chevron_left, size: screenWidth * 0.05, color: ColorManager.appBlack),
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
                  child: SizedBox(
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
              top: screenHeight * 0.85,
              left: screenWidth * 0.11,
              child: SizedBox(
                height: screenHeight * 0.065,
                width: screenWidth * 0.77,
                child: ElevatedButton(
                  onPressed: () => uploadImage(context),
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
                      fontSize: FontSize.s26,
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



// import 'package:evfi/presentation/login/profileImage.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:path/path.dart' as Path;
// import 'package:evfi/presentation/onboarding/onboarding.dart';
// import 'package:evfi/presentation/resources/color_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:evfi/presentation/resources/assets_manager.dart';
// import '../resources/font_manager.dart';
// import '../resources/strings_manager.dart';
// import 'dart:io';
//
// class ProfileUpload extends StatefulWidget {
//   @override
//   State<ProfileUpload> createState() => _ProfileUploadState();
//   final String imagePath;
//
//   const ProfileUpload({required this.imagePath});
// }
//
// class _ProfileUploadState extends State<ProfileUpload> {
//   double _scale = 1.0;
//   double _previousScale = 1.0;
//   Offset _offset = Offset.zero;
//   Future<void> uploadImage(BuildContext context) async {
//     print("here");
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         print('No user signed in');
//         // Handle the case when the user is not signed in
//         return;
//       }
//       FirebaseStorage storage = FirebaseStorage.instance;
//       Reference storageRef = storage.ref().child('profile_images');
//       String fileName = Path.basename(widget.imagePath);
//       UploadTask uploadTask = storageRef.child(fileName).putFile(File(widget.imagePath));
//
//       await uploadTask.whenComplete(() {
//         storageRef.child(fileName).getDownloadURL().then((url) {
//           print('Download URL: $url');
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => OnBoardingView()),
//           );
//         });
//       });
//     } catch (e) {
//       print('Error uploading image: $e');
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//         backgroundColor: ColorManager.appBlack,
//         body: Center(
//             child: Stack(
//               children: <Widget>[
//                 Positioned(
//                   top: screenHeight * 0.08,
//                   left:screenWidth * 0.05,
//                   child: SizedBox(
//                     height: screenHeight * 0.064,
//                     width: screenHeight * 0.064,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => ProfileImage()),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: ColorManager.primary,
//                         ),
//                         child: Row(
//                           children: <Widget>[
//                             Icon(Icons.chevron_left,size: screenWidth * 0.05,color: ColorManager.appBlack),
//                           ],
//                         ),
//                       ),
//                   ),
//                 ),
//                 Positioned(
//                   top: screenHeight * 0.15,
//                   left: screenWidth * 0.16,
//                   child: Image.asset(
//                     ImageAssets.circle,
//                     width: screenWidth * 0.7,
//                     height: screenWidth * 0.7,
//                   ),
//                 ),
//                 Positioned(
//                   top: screenHeight * 0.185,
//                   left: screenWidth * 0.235,
//                   child: GestureDetector(
//                     onScaleStart: (ScaleStartDetails details) {
//                       _previousScale = _scale;
//                     },
//                     onScaleUpdate: (ScaleUpdateDetails details) {
//                       setState(() {
//                         _scale = (_previousScale * details.scale).clamp(1.0, 3.0);
//                         _offset = details.focalPoint - Offset(screenWidth * 0.20, screenHeight * 0.20);
//                       });
//                     },
//                     child: ClipOval(
//                       child: Container(
//                         width: screenWidth * 0.55,
//                         height: screenWidth * 0.55,
//                         child: InteractiveViewer(
//                           minScale: 1.0,
//                           maxScale: 3.0,
//                           constrained: true,
//                           child: FittedBox(
//                             fit: BoxFit.cover,
//                             child: Image.file(
//                               File(widget.imagePath),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: screenHeight * 0.62,
//                   left: screenWidth * 0.18,
//                   child: Text(
//                     AppStrings.lookingClean,
//                     style: TextStyle(
//                       color: ColorManager.primary,
//                       fontSize: FontSize.s32,
//                       fontFamily: FontConstants.appTitleFontFamily,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 2.0,
//                     ),
//                   ),
//                 ),
//
//                 Positioned(
//                   top: screenHeight * 0.85,
//                   left: screenWidth * 0.11,
//                   child: SizedBox(
//                     height: screenHeight * 0.065,
//                     width: screenWidth * 0.77,
//                     child: ElevatedButton(
//                       onPressed: () => uploadImage(context),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: ColorManager.primary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(screenWidth * 0.02),
//                         ),
//                       ),
//                       child: Text(
//                         AppStrings.upload,
//                         style: TextStyle(
//                             color: ColorManager.appBlack,
//                             fontFamily: FontConstants.appTitleFontFamily,
//                             fontWeight: FontWeight.bold,
//                             fontSize: FontSize.s26
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//   }
// }
