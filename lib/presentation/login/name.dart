// import 'package:evfi_duplicate/onboarding1.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../onboarding/onboarding1.dart';
import '../storage/UserData.dart';
import '../storage/UserDataProvider.dart';

class Name extends StatefulWidget {
  @override
  _NameState createState() => _NameState();
}

class _NameState extends State<Name> {
  final Color myColor = Color.fromRGBO(208, 187, 30, 0.5);
  final Color myColor2 = Color.fromRGBO(99, 99, 95, 1);
  final Color mainColor = Color.fromRGBO(255, 216, 15, 1);

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    //  Storing user's name  using provider

    void StoreName(String name) {
      UserData userData = userDataProvider.userData;
      userData.name = name;
      userData.level1 = true;

      userDataProvider.setUserData(userData);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Image.asset(
              'assets/assetss/head.png',
              height: 130,
              width: 130,
            ),
            Image.asset(
              'assets/assetss/body.png',
              height: 200,
              width: 200,
            ),
            SizedBox(height: 80),
            Text(
              'what should',
              style: TextStyle(
                color: mainColor,
                fontSize: 30,
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
              'we call you',
              style: TextStyle(
                color: mainColor,
                fontSize: 30,
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
                  onChanged: (value) async {
                    // Store the entered name in the provider
                    setState(() {
                      nameController.text = value;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: myColor2,
                    hintText: 'OTP',
                    labelText: '',
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
            SizedBox(height: 10),
            SizedBox(
              height: 50,
              width: 330,
              child: ElevatedButton(
                onPressed: () async {
                  StoreName(nameController.text);
                  await userDataProvider.saveUserData();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Onboarding1()),
                  );
                  // Add your logic here
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10.0), // Set the border radius here
                  ),
                  primary: mainColor, // Button background color
                ),
                child: Text(
                  'next',
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
