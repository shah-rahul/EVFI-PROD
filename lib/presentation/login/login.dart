import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import '../register/register.dart';
import '../resources/font_manager.dart';
import '../resources/assets_manager.dart';
import '../resources/values_manager.dart';
import '../resources/color_manager.dart';
import '../onboarding/onboarding.dart';

import 'VerificationCodePage.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final phoneController = TextEditingController();
  final _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: phoneController.text.length,
      ),
    );
    return Scaffold(
      backgroundColor: ColorManager.appBlack,
      // appBar: AppBar(
      //   title: Text('Mobile verify'),
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: AppSize.s100),
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
                      fontSize: FontSize.s20,
                      color: ColorManager.primary,
                    ),
                  ),
                  Text(
                    'FI',
                    style: TextStyle(
                      fontFamily: FontConstants.fontFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.s20,
                      color: ColorManager.primary,
                    ),
                  ),
                ],
              )),
          SizedBox(height: height * 0.06),
          Container(
            margin: EdgeInsets.symmetric(horizontal: AppMargin.m20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: ColorManager.darkGrey.withOpacity(0.4),
            ),
            padding: EdgeInsets.all(AppPadding.p20),
            child: Column(
              children: [
                TextFormField(
                  style: TextStyle(color: Colors.black),
                  controller: phoneController,
                  onChanged: (value) {
                    setState(() {
                      phoneController.text = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    suffixIcon: phoneController.text.length > 11
                        ? Container(
                            height: 20,
                            width: 20,
                            decoration: const BoxDecoration(),
                            child: const Icon(
                              Icons.done,
                              color: Colors.green,
                              size: 20,
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    //  mobile number verification logic here
                    final String phoneNumber = phoneController.text.trim();
                    //  getPhoneNumber(phoneNumber);
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: phoneNumber,
                      verificationCompleted:
                          (PhoneAuthCredential credential) async {
                        //  Authenticate user with credential
                      },
                      verificationFailed: (FirebaseAuthException e) {
                        //  Handle verification failure
                      },
                      codeSent: (String verificationId, int? resendToken) {
                        // Save verification ID and navigate to verification code page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerificationCodePage(
                              verificationId: verificationId,
                              phoneNumber: phoneNumber,
                            ),
                          ),
                        );
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {
                        //  Handle code auto retrieval timeout
                      },
                    );
                    // Navigator.pushNamed(context, '/verify_otp');
                  },
                  child: Text('Get OTP'),
                ),
              ],
            ),
          ),
          // SizedBox(height: 16.0),
          // OTPTextField(
          //   // controller: _otpController,
          //   length: 6,
          //   width: MediaQuery.of(context).size.width,
          //   fieldWidth: 20,
          //   style: TextStyle(fontSize: 17),
          //   textFieldAlignment: MainAxisAlignment.spaceAround,
          //   fieldStyle: FieldStyle.underline,
          //   onCompleted: (pin) {
          //     //   OTP verification logic here
          //   },
          // ),
        ],
      ),
    );
  }
}
