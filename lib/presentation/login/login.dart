import 'package:evfi/presentation/login/signUp.dart';
import 'package:evfi/presentation/login/verify.dart';
import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../resources/assets_manager.dart';
import '../resources/font_manager.dart';
import '../resources/strings_manager.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColorManager.appBlack,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          //Close the keyboard when tapped outside the text field
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
                  height: screenHeight * 0.36,
                  width: screenWidth * 0.8,
                ),

                SizedBox(height: screenHeight * 0.08),
                Text(
                  AppStrings.login,
                  style: TextStyle(
                    color: ColorManager.primary,
                    fontSize: FontSize.s50,
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
                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  height: screenHeight * 0.03,
                  width: screenWidth * 0.3,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                    },
                    child: Text(
                      AppStrings.SignUp,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: FontSize.s14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.1),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: SizedBox(
                    child: IntlPhoneField(
                    
                      initialCountryCode: 'IN',
                      cursorColor: ColorManager.primary,
                      dropdownTextStyle:
                          TextStyle(color: ColorManager.darkGrey),
                      disableLengthCheck: false,
                      
                      decoration: InputDecoration(
                          counterText: '',
                        filled: true,
                        fillColor: ColorManager.grey4,
                        // hintText: '7303440170',
                        labelText: 'Phone Number',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                            horizontal: screenWidth * 0.1),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ColorManager.primary.withOpacity(0.5)),
                          borderRadius: BorderRadius.all(
                              Radius.circular(screenWidth * 0.02)),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: FontSize.s12,
                        ),
                        hintStyle: TextStyle(
                          color: ColorManager.appBlack,
                        ),
                      ),
                      languageCode: "en",
                      onChanged: (phone) {
                        setState(() {
                          print(phone);
                          phoneController.text =
                              phone.completeNumber.toString();
                        });
                      },
                      onCountryChanged: (country) {
                        print('Country changed to: ' + country.name);
                      },
                    ),
                    // TextField(
                    //   onChanged: (value) {
                    //     setState(() {
                    //       phoneController.text = "+91" + value;
                    //     });
                    //   },
                    //   decoration: InputDecoration(
                    //     filled: true,
                    //     fillColor: ColorManager.grey4,
                    //     hintText: '+91- 7303440170',
                    //     labelText: 'Phone Number',
                    //     contentPadding: EdgeInsets.symmetric(
                    //         vertical: screenHeight * 0.02,
                    //         horizontal: screenWidth * 0.1),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //           color: ColorManager.primary.withOpacity(0.5)),
                    //       borderRadius: BorderRadius.all(
                    //           Radius.circular(screenWidth * 0.02)),
                    //     ),
                    //     labelStyle: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: FontSize.s12,
                    //     ),
                    //     hintStyle: TextStyle(
                    //       color: ColorManager.appBlack,
                    //     ),
                    //   ),
                    //   style: TextStyle(color: ColorManager.appBlack),
                    // ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                SizedBox(
                  height: screenHeight * 0.06,
                  width: screenWidth * 0.8,
                  child: ElevatedButton(
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
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              // child: VerificationCodePage(
                              //   verificationId: verificationId,
                              //   phoneNumber: phoneNumber,
                              // ),
                              child: Verify(
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
                    },
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => Verify()),
                    //   );
                    // },
                    style: ElevatedButton.styleFrom(backgroundColor:ColorManager.primary ,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      ),
                      // primary: ColorManager.primary,
                    ),
                    child: Text(
                      AppStrings.otp,
                      style: TextStyle(
                        color: ColorManager.appBlack,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.s20,
                      ),
                    ),
                  ),
                ),
                // Rest of your widgets
              ],
            ),
          ),
        ),
      ),
     );
  }
}
