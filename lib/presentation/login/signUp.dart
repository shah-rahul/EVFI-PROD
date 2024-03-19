// import 'package:evfi/presentation/login/login.dart';
// import 'package:evfi/presentation/login/verify.dart';
// import 'package:evfi/presentation/resources/color_manager.dart';
// import 'package:flutter/material.dart';
// import '../resources/assets_manager.dart';
// import '../resources/font_manager.dart';
// import '../resources/strings_manager.dart';
// import '../resources/values_manager.dart';
// import '../resources/routes_manager.dart';

// class SignupPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: ColorManager.appBlack,
//       resizeToAvoidBottomInset: true,
//       body: GestureDetector(
//         onTap: () {
//           // Close the keyboard when tapped outside the text field
//           FocusScope.of(context).unfocus();
//         },
//         child: SingleChildScrollView(
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 SizedBox(height: screenHeight * 0.10),
//                 Image.asset(
//                   ImageAssets.logo3D,
//                   height: screenWidth * 0.8,
//                   width: screenWidth * 0.8,
//                 ),
//                 SizedBox(height: screenHeight * 0.07),
//                 Text(
//                   AppStrings.registerSignup,
//                   style: TextStyle(
//                     color: ColorManager.primary,
//                     fontSize: FontSize.s50,
//                     fontFamily: 'fonts/Poppins',
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 2.0,
//                     shadows: <Shadow>[
//                       Shadow(
//                           offset: Offset(-5.0, 4.0),
//                           color: ColorManager.dullYellow,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: screenHeight * 0.02),
//                 SizedBox(
//                   height: screenWidth * 0.05,
//                   width: screenWidth * 0.3,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => LoginView()),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       primary: ColorManager.appBlack,
//                     ),
//                     child: Text(
//                       AppStrings.orLogin,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: FontSize.s14,
//                         fontFamily: 'Poppins',
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: screenHeight * 0.12),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
//                   child: SizedBox(
//                     child: TextField(
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: ColorManager.grey4,
//                         hintText: '+91- 7303440170',
//                         labelText: 'Phone Number',
//                         contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.02, horizontal: screenWidth * 0.1),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: ColorManager.primary.withOpacity(0.5)),
//                             borderRadius: BorderRadius.all(Radius.circular(screenWidth * 0.02))
//                         ),
//                         labelStyle: TextStyle(
//                           color: Colors.white,
//                           fontSize: FontSize.s12,
//                         ),
//                         hintStyle: TextStyle(
//                           color: ColorManager.appBlack,
//                         ),
//                       ),
//                       style: TextStyle(color: ColorManager.appBlack),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: screenHeight * 0.03),
//                 SizedBox(
//                   height: screenHeight * 0.06,
//                   width: screenWidth * 0.8,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => Verify(phoneNumber: '', verificationId: '',)),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(screenWidth * 0.02),
//                       ),
//                       primary: ColorManager.primary,
//                     ),
//                     child: Text(
//                       AppStrings.otp,
//                       style: TextStyle(
//                           color: ColorManager.appBlack,
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.bold,
//                           fontSize: FontSize.s20
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Rest of your widgets
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:evfi/presentation/login/name.dart';
import 'package:evfi/presentation/register/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:evfi/presentation/login/login.dart';
import 'package:evfi/presentation/login/verify.dart';
import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:page_transition/page_transition.dart';
import '../resources/assets_manager.dart';
import '../resources/font_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import '../resources/routes_manager.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
                    height: screenHeight * 0.32,
                    width: screenWidth * 0.31
                ),
                SizedBox(height: screenHeight * 0.08),
                Text(
                  AppStrings.SignUp,
                  style: TextStyle(
                    color: ColorManager.primary,
                    fontSize: FontSize.s66,
                    fontFamily: FontConstants.appTitleFontFamily,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3.0,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(3.0, 2.0),
                        color: ColorManager.primary20,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.021),
                SizedBox(
                  height: screenHeight * 0.03,
                  width: screenWidth * 0.3,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginView()),
                      );
                    },
                    child: Text(
                      AppStrings.login,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: FontSize.s14,
                        letterSpacing: 1,
                        fontFamily: FontConstants.appTitleFontFamily,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.14),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: SizedBox(
                      height: screenHeight * 0.07,
                      width: screenWidth * 0.77,
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
                    )),
                SizedBox(height: screenHeight * 0.025),
                SizedBox(
                  height: screenHeight * 0.065,
                  width: screenWidth * 0.77,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => Verify(
                      //       phoneNumber: '',
                      //       verificationId: '',
                      //     ),
                      //   ),
                      // );

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
                                // child: Verify(
                                //   verificationId: verificationId,
                                //   phoneNumber: phoneNumber,
                                // ),
                                child: Name(phoneNumber: phoneNumber)),
                          );
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {
                          //  Handle code auto retrieval timeout
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor:  ColorManager.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      ),
                      // primary: ColorManager.primary,
                    ),
                    child: Text(
                      AppStrings.otp,
                      style: TextStyle(
                        color: ColorManager.appBlack,
                        fontFamily: FontConstants.appTitleFontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.s26,
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
