import 'package:EVFI/presentation/splash/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColorManager.appBlack,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: height * 0.16),
                height: height * 0.2,
                child: Image.asset(ImageAssets.logo),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ev',
                      style: TextStyle(
                        fontSize: AppSize.s28,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'FI',
                      style: TextStyle(
                        fontFamily: FontConstants.fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: AppSize.s28,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.06),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppMargin.m20),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: ColorManager.darkGreyOpacity40,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3,
                      color: ColorManager.darkGrey,
                      offset: const Offset(-1, -1),
                    ),
                    const BoxShadow(
                      blurRadius: 6,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(AppPadding.p20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          bottom: AppPadding.p30, top: AppPadding.p8),
                      child: const Text(
                        'Verify OTP',
                        style: TextStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontWeight: FontWeight.w300,
                          fontSize: AppSize.s28,
                          color: Colors.white,
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
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        controller: _codeController,
                        decoration: const InputDecoration(
                          hintText: 'Verification code',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      child: const Text('Verify Code'),
                      onPressed: () async {
                        //  Verify code
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

                          var sharedPref =
                              await SharedPreferences.getInstance();
                          sharedPref.setBool(SplashViewState.keyLogin, true);

                          // prefs.setString('uid', userCredential.user!.uid);

                          //If Successfully Logged in(Creds are correct)

                          // Navigator.pushReplacement(
                          //   context,

                          // //  MaterialPageRoute(builder: (context) => OnBoardingView()),
                          //    MaterialPageRoute(builder: (context) => RegisterView()),

                          // );
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: RegisterView(
                                phoneNumber: widget.phoneNumber,
                              ),
                            ),
                          );
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
}
