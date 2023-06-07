import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

import '../onboarding/onboarding.dart';
import 'VerificationCodePage.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    _phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: _phoneController.text.length,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile verify'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              style: TextStyle(color: Colors.black),
              controller: _phoneController,
              onChanged: (value) {
                setState(() {
                  _phoneController.text = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Phone Number',
                suffixIcon: _phoneController.text.length > 11
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
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                //  mobile number verification logic here
                final String phoneNumber = _phoneController.text.trim();
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
    );
  }
}
