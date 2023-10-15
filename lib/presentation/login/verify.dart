// import 'package:evfi_duplicate/profileImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evfi/presentation/login/profileImage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main/main_view.dart';
import '../register/register.dart';
import '../splash/splash.dart';
import '../storage/UserData.dart';
import '../storage/UserDataProvider.dart';

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
  final Color myColor = Color.fromRGBO(208, 187, 30, 0.5);
  final Color myColor2 = Color.fromRGBO(99, 99, 95, 1);
  final Color mainColor = Color.fromRGBO(255, 216, 15, 1);
  final TextEditingController _codeController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('user');
  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);

    // ignore: non_constant_identifier_names
    void StorePhoneNumber(String phoneNumber) {
      UserData userData = userDataProvider.userData;
      userData.phoneNumber = phoneNumber;

      userDataProvider.setUserData(userData);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            Image.asset(
              'assets/assetss/logo.png',
              height: 350,
              width: 350,
            ),
            SizedBox(height: 30),
            Text(
              'almost',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 52,
                fontFamily: 'fonts/Poppins',
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(-5.0, 4.0),
                    color: myColor,
                  ),
                ],
              ),
            ),
            Text(
              'there',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 52,
                fontFamily: 'fonts/Poppins',
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(-5.0, 4.0),
                    color: myColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                height: 60,
                child: TextField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: myColor2,
                    hintText: 'OTP',
                    labelText: '**********',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 105),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: mainColor.withOpacity(0.5)),
                      borderRadius: BorderRadius.all(Radius.circular(
                          10)), // Border color when the TextField is not focused
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: 330,
              child: ElevatedButton(
                onPressed: () async {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ProfileImage()),
                  // );

                  // Add your login logic here
                  final String code = _codeController.text.trim();
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: code,
                  );
                  try {
                    // ignore: unused_local_variable
                    UserCredential userCredential = await FirebaseAuth.instance
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
                    borderRadius: BorderRadius.circular(
                        10.0), // Set the border radius here
                  ),
                  primary: mainColor, // Button background color
                ),
                child: Text(
                  'Verify',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            // Rest of your widgets
          ],
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
