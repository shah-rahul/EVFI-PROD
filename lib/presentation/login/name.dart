import 'package:controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:evfi/presentation/resources/color_manager.dart';
import '../onboarding/onboarding1.dart';
import '../storage/UserData.dart';
import '../storage/UserDataProvider.dart';
import 'package:evfi/presentation/resources/assets_manager.dart';
import '../resources/font_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import '../resources/routes_manager.dart';


class Name extends StatefulWidget {
  @override
  _NameState createState() => _NameState();
}

class _NameState extends State<Name> {

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final userDataProvider = Provider.of<UserDataProvider>(context);
    //  Storing user's name  using provider
    void StoreName(String name) {
      UserData userData = userDataProvider.userData;
      userData.name = name;
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
                SizedBox(height: screenHeight * 0.10),
                Text(
                  AppStrings.whatShould,
                  style: TextStyle(
                    color: ColorManager.primary,
                    fontSize: FontSize.s35,
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
                    fontSize: FontSize.s35,
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
                SizedBox(height: screenHeight * 0.18),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ColorManager.grey4,
                      hintText: 'abc',
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
                        context,
                        MaterialPageRoute(builder: (context) => Onboarding1()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      ),
                      primary: ColorManager.primary,
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