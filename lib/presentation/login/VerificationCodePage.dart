import 'package:EVFI/presentation/splash/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../onboarding/onboarding.dart';
import '../register/register.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class VerificationCodePage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  VerificationCodePage({
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Phone Number'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter the verification code sent to ${widget.phoneNumber}',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: TextFormField(
                style: TextStyle(color: Colors.black),
                controller: _codeController,
                decoration: InputDecoration(
                  hintText: 'Verification code',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Verify Code'),
              onPressed: () async {
                //  Verify code
                final String code = _codeController.text.trim();
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: code,
                );
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .signInWithCredential(credential);
                  //  Handle successful authentication

                  var sharedPref = await SharedPreferences.getInstance();
                  sharedPref.setBool(SplashViewState.KEYLOGIN,true);
                  
                  // prefs.setString('uid', userCredential.user!.uid);

                  //If Successfully Logged in(Creds are correct)

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => OnBoardingView()),
                    // MaterialPageRoute(builder: (context) => RegisterView()),
                  );
                } on FirebaseAuthException catch (e) {
                  //  Handle authentication failure
                  if (e.code == 'invalid-verification-code') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Invalid verification code'),
                          content:
                              Text('Please enter a valid verification code.'),
                          actions: [
                            ElevatedButton(
                              child: Text('OK'),
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
                          title: Text('Authentication failed'),
                          content: Text('Please try again later.'),
                          actions: [
                            ElevatedButton(
                              child: Text('OK'),
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
    );
  }
}
