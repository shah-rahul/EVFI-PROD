import 'package:evfi/presentation/login/profileImage.dart';

import '../resources/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../storage/UserDataProvider.dart';
import 'package:page_transition/page_transition.dart';
import '../resources/color_manager.dart';
import '../resources/assets_manager.dart';
import '../login/signup_controller.dart';
import 'package:get/get.dart';
import '../storage/UserData.dart';
import '../resources/font_manager.dart';



class Name extends StatefulWidget {

  final String phoneNumber;
  Name({
    required this.phoneNumber,
  });

  @override
  _NameState createState() => _NameState();
}

class _NameState extends State<Name> {

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final userDataProvider = Provider.of<UserDataProvider>(context);
    //  Storing user's name  using provider
    void StoreName(String name) {
      UserData userData = userDataProvider.userData;
      userData.firstName = name;
      userData.level1 = true;
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
              children: <Widget>[
                SizedBox(height: screenHeight * 0.10),
                FractionallySizedBox(
                  widthFactor: 0.3,
                  child: Image.asset(
                    ImageAssets.head,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                FractionallySizedBox(
                  widthFactor: 0.4,
                  child: Image.asset(
                    ImageAssets.body,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: screenHeight * 0.18),
                Text(
                  AppStrings.whatShould,
                  style: TextStyle(
                    color: ColorManager.primary,
                    fontSize: FontSize.s28,
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
                  AppStrings.weCallYou,
                  style: TextStyle(
                    color: ColorManager.primary,
                    fontSize: FontSize.s28,
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
                SizedBox(height: screenHeight * 0.13),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: TextField(
                    onChanged: (value) async {
                    // Store the entered name in the provider
                    setState(() {
                      nameController.text = value;
                    });
                  },
                      decoration: InputDecoration(
                      filled: true,
                      fillColor: ColorManager.grey4,
                      hintText: 'Enter your name',
                      labelText: 'Name',
                      contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.015, horizontal: screenWidth * 0.10),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorManager.primary.withOpacity(0.5)),
                        borderRadius: BorderRadius.all(Radius.circular(screenWidth * 0.02)),
                      ),
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: FontSize.s12,
                      ),
                      hintStyle: TextStyle(
                        color: ColorManager.appBlack,
                      ),
                    ),
                    style: TextStyle(color: ColorManager.appBlack),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  height: screenHeight * 0.06,
                  width: screenWidth * 0.8,
                  child: ElevatedButton(
                    onPressed: () async {
                      StoreName(nameController.text);
                      await userDataProvider.saveUserData();

                      Navigator.push(
                        context, PageTransition(
                            type: PageTransitionType.rightToLeft,


                            // child: OnBoardingView()),
                            child: ProfileImage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor:  ColorManager.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      ),
                      // primary: ColorManager.primary,
                    ),
                    child: Text(
                      AppStrings.next,
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