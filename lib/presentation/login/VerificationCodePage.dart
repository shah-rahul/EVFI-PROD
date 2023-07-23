import 'package:EVFI/presentation/main/main_view.dart';
import 'package:EVFI/presentation/splash/splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Data_storage/UserData.dart';
import '../Data_storage/UserDataProvider.dart';
import '../resources/color_manager.dart';
import '../resources/assets_manager.dart';
import '../resources/values_manager.dart';
import '../resources/font_manager.dart';
import 'package:page_transition/page_transition.dart';
import '../register/register.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class VerificationCodePage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const VerificationCodePage({
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final TextEditingController _codeController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('UserChargingRegister');
  Widget build(BuildContext context) {
    final double heightScreen = MediaQuery.of(context).size.height;

    final userDataProvider = Provider.of<UserDataProvider>(context);

    void StorePhoneNumber(String phoneNumber) {
      UserData userData = userDataProvider.userData;
      userData.phoneNumber = phoneNumber;

      userDataProvider.setUserData(userData);
    }

    return Container(
      decoration: new BoxDecoration(
          image: new DecorationImage(
        image: new AssetImage(ImageAssets.loginBackground),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: heightScreen * 0.46,
                margin: EdgeInsets.only(
                    top: heightScreen * 0.46,
                    left: AppMargin.m14,
                    right: AppMargin.m14),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: Colors.white.withOpacity(0.90),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      color: ColorManager.shadowBottomRight.withOpacity(0.3),
                      offset: const Offset(4, 4),
                    ),
                    BoxShadow(
                      blurRadius: 2,
                      color: ColorManager.shadowTopLeft.withOpacity(0.4),
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(AppPadding.p20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          bottom: AppPadding.p30, top: AppPadding.p8),
                      child: Text(
                        'Verify OTP',
                        style: TextStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontWeight: FontWeight.w300,
                          fontSize: AppSize.s28,
                          color: ColorManager.darkGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          bottom: AppPadding.p12, top: AppPadding.p12),
                      child: Text(
                        'Enter the verification code sent to ${widget.phoneNumber}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: ColorManager.darkGrey),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        controller: _codeController,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: AppSize.s4 - 3,
                                color: ColorManager.darkGrey),
                          ),
                          hintText: 'Verification code',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shadowColor: Colors.white,
                          elevation: 6),
                      child: Text(
                        'Verify Code',
                        style: TextStyle(color: ColorManager.darkGrey),
                      ),
                      onPressed: () async {
                        //  Verify code
                        // StorePhoneNumber(widget.phoneNumber);

                        final String code = _codeController.text.trim();
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                          verificationId: widget.verificationId,
                          smsCode: code,
                        );
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .signInWithCredential(credential);
                          //  Handle successful authentication
                          // await userDataProvider.saveUserData();
                          // UserData? userData = userDataProvider.userData;
                          // userDataProvider.setUserData(userData);
                          var sharedPref =
                              await SharedPreferences.getInstance();
                          sharedPref.setBool(SplashViewState.keyLogin, true);

                          Future<bool> check = checkNumberIsRegistered(
                              number: widget.phoneNumber);

                          if (await check) {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: MainView(),
                              ),
                            );
                          } else {
                            StorePhoneNumber(widget.phoneNumber);
                            await userDataProvider.saveUserData();
                            UserData? userData = userDataProvider.userData;
                            userDataProvider.setUserData(userData);
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: RegisterView(
                                  phoneNumber: widget.phoneNumber,
                                ),
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
                                  title:
                                      const Text('Invalid verification code'),
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
                                  content:
                                      const Text('Please try again later.'),
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> checkNumberIsRegistered({required String number}) async {
    final firestore = FirebaseFirestore.instance;
    final collectionRef = firestore.collection('UserChargingRegister');
    bool isNumberRegistered = false;
    // storePhoneNumber(number);

    try {
      final querySnapshot = await collectionRef.get();

      for (var doc in querySnapshot.docs) {
        final phoneNumber = doc.data()['Phone Number'].toString();

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
}
