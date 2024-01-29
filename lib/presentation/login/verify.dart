import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evfi/presentation/login/profileImage.dart';
import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../resources/assets_manager.dart';
import '../resources/font_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import '../resources/routes_manager.dart';
import '../main/main_view.dart';
import '../register/register.dart';
import '../splash/splash.dart';
import '../storage/UserData.dart';
import '../storage/UserDataProvider.dart';
import 'package:pinput/pinput.dart';

class Verify extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  // ignore: use_key_in_widget_constructors
  const Verify({
    required this.verificationId,
    required this.phoneNumber,
  });
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final TextEditingController _codeController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('user');
  String _enteredOTP = '';
  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // ignore: non_constant_identifier_names
    void StorePhoneNumber(String phoneNumber) {
      UserData userData = userDataProvider.userData;
      userData.phoneNumber = phoneNumber;

      userDataProvider.setUserData(userData);
    }

    return Scaffold(
      backgroundColor: ColorManager.appBlack,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          // Close the keyboard when tapped outside the text field
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: screenHeight * 0.10),
                Image.asset(
                  ImageAssets.logo3D,
                  height: screenWidth * 0.6,
                  width: screenWidth * 0.8,
                ),
                SizedBox(height: screenHeight * 0.07),
                Text(
                  AppStrings.almost,
                  style: TextStyle(
                    color: ColorManager.primary,
                    fontSize: FontSize.s35,
                    fontFamily: 'fonts/Poppins',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(-5.0, 4.0),
                        color: ColorManager.dullYellow,
                      ),
                    ],
                  ),
                ),
                Text(
                  AppStrings.there,
                  style: TextStyle(
                    color: ColorManager.primary,
                    fontSize: FontSize.s35,
                    fontFamily: 'fonts/Poppins',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(-5.0, 4.0),
                        color: ColorManager.dullYellow,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.08),
                //Textfield of OTP starts here..........................................
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: SizedBox(
                    child: Pinput(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      length: 6,
                      showCursor: true,
                      animationCurve: Curves.bounceInOut,
                      closeKeyboardWhenCompleted: true,
                      onCompleted: (value) {
                        print('The entered OTP is $_enteredOTP');
                        _enteredOTP = value;
                      },
                      defaultPinTheme: PinTheme(
                          height: screenHeight * 0.06,
                          width: screenWidth * 0.8 / 6,
                          textStyle: TextStyle(
                            fontSize: FontSize.s35,
                            color: ColorManager.primary,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'fonts/Poppins',
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white38),
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.02),
                          )),
                      focusedPinTheme: PinTheme(
                          height: screenHeight * 0.06,
                          width: screenWidth * 0.8 / 6,
                          textStyle: TextStyle(
                            fontSize: FontSize.s35,
                            color: ColorManager.primary,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'fonts/Poppins',
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            border: Border.all(
                              color: ColorManager.primary,
                            ),
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.02),
                          )),
                    ),
                  ),
                ),
                //  Padding(
                //    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                //    child: SizedBox(
                //      child: TextField(
                //           controller: _codeController,
                //        decoration: InputDecoration(
                //          filled: true,
                //          fillColor: ColorManager.grey4,
                //          hintText: '******',
                //          labelText: 'OTP',
                //          contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.02, horizontal: screenWidth * 0.1),
                //          enabledBorder: OutlineInputBorder(
                //            borderSide: BorderSide(color: ColorManager.primary.withOpacity(0.5)),
                //            borderRadius: BorderRadius.all(Radius.circular(screenWidth * 0.02)),
                //          ),
                //          labelStyle: TextStyle(
                //            color: Colors.white,
                //            fontSize: FontSize.s12,
                //          ),
                //          hintStyle: TextStyle(
                //            color: ColorManager.appBlack,
                //          ),
                //        ),
                //        style: TextStyle(color: ColorManager.appBlack),
                //      ),
                //    ),
                //  ),
                //Textfield of OTP ends here..........................................
                SizedBox(height: screenHeight * 0.03),
                SizedBox(
                  height: screenHeight * 0.06,
                  width: screenWidth * 0.8,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => ProfileImage()),
                      // );

                      final String code = _enteredOTP;
                      print('OTP = $code');
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                        verificationId: widget.verificationId,
                        smsCode: code,
                      );
                      try {
                        // ignore: unused_local_variable
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithCredential(credential);

                        var sharedPref = await SharedPreferences.getInstance();
                        sharedPref.setBool(SplashViewState.keyLogin, true);

                        Future<bool> check =
                            checkNumberIsRegistered(number: widget.phoneNumber);

                        if (await check) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: MainView(),
                            ),
                          );
                        } else {
                          StorePhoneNumber(widget.phoneNumber);

                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              // child: RegisterView(
                              //   phoneNumber: widget.phoneNumber,
                              // ),
                              child: ProfileImage(),
                            ),
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        //  Handle authentication failure
                        if (e.code == 'invalid-verification-code') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Invalid verification code'),
                                content: const Text(
                                    'Please enter a valid verification code.'),
                                actions: [
                                  ElevatedButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Authentication failed'),
                                content: const Text('Please try again later.'),
                                actions: [
                                  ElevatedButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      ),
                      primary: ColorManager.primary,
                    ),
                    child: Text(
                      AppStrings.verify,
                      style: TextStyle(
                        color: ColorManager.appBlack,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.s20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> checkNumberIsRegistered({required String number}) async {
  final firestore = FirebaseFirestore.instance;
  final collectionRef = firestore.collection('user');
  bool isNumberRegistered = false;
  // storePhoneNumber(number);

  try {
    final querySnapshot = await collectionRef.get();

    for (var doc in querySnapshot.docs) {
      final phoneNumber = doc.data()['phoneNumber'].toString();

      if (number == phoneNumber) {
        isNumberRegistered = true;
        break;
      } else {
        // storePhoneNumber(number);
      }
    }

    return isNumberRegistered;
  } catch (e) {
    return false;
  }
}