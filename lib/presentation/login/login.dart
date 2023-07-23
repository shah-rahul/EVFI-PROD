import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Data_storage/UserData.dart';
import '../Data_storage/UserDataProvider.dart';
import '../resources/font_manager.dart';
import '../resources/assets_manager.dart';
import '../resources/values_manager.dart';
import '../resources/color_manager.dart';
import 'package:page_transition/page_transition.dart';
import 'VerificationCodePage.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final phoneController = TextEditingController();
 
  @override
  @override
  Widget build(BuildContext context) {
    final double heightScreen = MediaQuery.of(context).size.height;
    final userDataProvider = Provider.of<UserDataProvider>(context);

  

    phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: phoneController.text.length,
      ),
    );
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
            children: <Widget>[
              Container(
                height: heightScreen * 0.40,
                margin: EdgeInsets.only(
                    top: heightScreen * 0.50,
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
                          bottom: AppPadding.p30,
                          top: AppPadding.p12 + AppPadding.p12),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          fontFamily: FontConstants.fontFamily,
                          fontWeight: FontWeight.w300,
                          fontSize: AppSize.s28 + 2,
                          color: ColorManager.darkGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TextFormField(
                      style: TextStyle(color: ColorManager.darkGrey),
                      //controller: phoneController,
                      onChanged: (value) {
                        // Store the entered phone number in the provider
                       // StorePhoneNumber(value);
                        setState(() {
                          phoneController.text = value;
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: AppSize.s4 - 3,
                                color: ColorManager.darkGrey)),
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
                      //  onChanged: (Value) {
                      //     StorePhoneNumber(Value);
                      //   },
                    ),
                    SizedBox(height: heightScreen * 0.05),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shadowColor: Colors.white,
                          elevation: 6),
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
                                child: VerificationCodePage(
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
                      child: Text(
                        'Get OTP',
                        style: TextStyle(
                          color: ColorManager.darkGrey,
                        ),
                      ),
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
