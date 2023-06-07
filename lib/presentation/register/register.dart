import 'package:EVFI/presentation/main/main_view.dart';

import 'package:EVFI/presentation/resources/strings_manager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import './vehicleform.dart';
import 'package:page_transition/page_transition.dart';
import '../resources/color_manager.dart';
import '../resources/assets_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/values_manager.dart';
import '../login/login.dart';
import 'package:EVFI/presentation/store_details/user_model.dart';
//import 'package:controller/controller.dart';

import '../store_details/user_model.dart';
// import '../pages/home.dart';
import '../login/signup_controller.dart';

import 'package:get/get.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({
    Key? key,
  }) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController nameController = TextEditingController();
  String phoneNumber = "";
  bool loading = false;
  //Reference for firebase realtime database name as user
  final databaseRef = FirebaseDatabase.instance.ref('user');
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorManager.appBlack,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: AppSize.s100),
              height: AppSize.s100 + 80,
              child: Image.asset(ImageAssets.logo),
            ),
            // Container(
            //   alignment: Alignment.center,
            //   margin: EdgeInsets.only(top: AppSize.s12),
            //   padding: const EdgeInsets.all(10),
            //   child: Text(
            //     'Join EVFI',
            //     style: TextStyle(
            //         color: ColorManager.primary,
            //         fontWeight: FontWeight.w500,
            //         fontSize: 30),
            //   ),
            // ),
            SizedBox(
              height: AppSize.s40,
            ),
            Container(
              height: height * 0.7,
              child: ListView(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: AppMargin.m12),
                    child: Text(
                      AppStrings.registertitle,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: AppMargin.m12),
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      AppStrings.registertitle2,
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorManager.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: AppMargin.m20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: ColorManager.darkGrey.withOpacity(0.4),
                    ),
                    padding: EdgeInsets.all(AppPadding.p20),
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Container(
                            child: Image.asset(ImageAssets.registerDp,
                                width: MediaQuery.of(context).size.width -
                                    AppSize.s200),
                          ),

                          // child: CircleAvatar(
                          //   backgroundColor: ColorManager.primary,
                          //   radius: 42,
                          //   child: CircleAvatar(
                          //     radius: 50,
                          //     backgroundImage:
                          //         AssetImage(ImageAssets.registerDp),
                          //   ),
                          // ),
                          onTap: () {
                            //upload prfile dp
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppPadding.p8,
                              vertical: AppPadding.p8),
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: ColorManager.darkGrey,
                                  ),
                                ),
                                labelText: 'User Name',
                                labelStyle: TextStyle(fontSize: AppSize.s14)),
                          ),
                        ),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: AppPadding.p8,
                        //       vertical: AppPadding.p8),
                        //   child: TextField(

                        //     controller: passwordController,
                        //     decoration: InputDecoration(
                        //         enabledBorder: UnderlineInputBorder(
                        //           borderSide: BorderSide(
                        //             width: 1,
                        //             color: ColorManager.darkGrey,
                        //           ),
                        //         ),
                        //         labelText: 'Password',
                        //         labelStyle: TextStyle(fontSize: AppSize.s14)),
                        //   ),
                        // ),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: AppPadding.p8,
                        //       vertical: AppPadding.p8),
                        //   child: TextField(
                        //     obscureText: true,
                        //     style: TextStyle(color: ColorManager.darkGrey),
                        //     controller: verifypasswordController,
                        //     decoration: InputDecoration(
                        //         enabledBorder: UnderlineInputBorder(
                        //           borderSide: BorderSide(
                        //             width: 1,
                        //             color: ColorManager.darkGrey,
                        //           ),
                        //         ),
                        //         labelText: 'Verify Password',
                        //         labelStyle: TextStyle(fontSize: AppSize.s14)),
                        //   ),
                        // ),
                        SizedBox(
                          height: 20,
                        ),

                        // TextButton(
                        //   onPressed: () {
                        //     //forgot password screen
                        //   },
                        //   child: const Text(
                        //     'Forgot Password',
                        //     style: TextStyle(fontSize: 18, color: Colors.amberAccent),
                        //   ),
                        // ),
                        Row(
                          children: [
                            Container(
                              height: AppSize.s60 - 5,
                              width: width * 0.3,
                              margin: EdgeInsets.only(
                                top: AppMargin.m20,
                              ),
                              padding: const EdgeInsets.only(
                                  left: AppPadding.p8, right: AppPadding.p8),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, Routes.loginRoute);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      ColorManager.darkGrey.withOpacity(0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  // side: BorderSide(color: Colors.white)),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 15),
                                  textStyle:
                                      const TextStyle(fontSize: AppSize.s18),
                                ),
                                child: const Text(AppStrings.registercancel),
                              ),

                              // print(nameController.text);
                              // print(passwordController.text);
                            ),
                            Container(
                              height: AppSize.s60 - 5,
                              width: width * 0.43,
                              margin: EdgeInsets.only(
                                  top: AppMargin.m20, left: AppMargin.m20),
                              // padding: const EdgeInsets.only(right: AppPadding.p20),
                              child: ElevatedButton(
                                onPressed: () {
                                  // final user = UserModel(
                                  //     fullName: nameController.text.trim(),
                                  //     phoneNo: phoneNumber);
                                  // var phoneController;
                                  // Generate a unique key for each user
                                  // void _getPhoneNumber(String phoneNumber) {
                                  //   this.phoneNumber;
                                  // }

                                  var userKey =
                                      databaseRef.child('user').push().key;

// Create a new user object
                                  var newUser = {
                                    'name': nameController.text.toString(),
                                    'phone': phoneNumber,
                                  };
// Add the new user under the unique key
                                  databaseRef
                                      .child('users/$userKey')
                                      .set(newUser)
                                      .then((value) {
                                    // Code to execute after the data is successfully saved.
                                    print('User added successfully!');
                                  }).catchError((error) {
                                    // Code to handle any errors that occurred during the data saving process.
                                    print('Error adding user: $error');
                                  });
                                  // databaseRef.set({
                                  //   'name': nameController.text.toString(),
                                  //   'phone': phoneNumber,
                                  // }).then((value) {
                                  //   // Code to execute after the data is successfully saved.
                                  //   print('Data saved successfully!');
                                  // }).catchError((error) {
                                  //   // Code to handle any errors that occurred during the data saving process.
                                  //   print('Error saving data: $error');
                                  // });
                                  // SignUpController.instance.createUser(user);
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: VehicleForm()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      ColorManager.primary.withOpacity(0.9),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 15),
                                  textStyle:
                                      const TextStyle(fontSize: AppSize.s18),
                                ),
                                child: const Text(AppStrings.registerSignup),
                              ),

                              // print(nameController.text);
                              // print(passwordController.text);
                            ),
                          ],
                        ),
                      ],

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: <Widget>[
                      //     const Text('Does not have account?'),
                      //     TextButton(
                      //       child: const Text(
                      //         'Sign up',
                      //         style: TextStyle(
                      //             fontSize: 20, color: Colors.amberAccent),
                      //       ),
                      //       onPressed: () {
                      //         //signup screen
                      //         Navigator.pushNamed(context, '/login');
                      //       },
                      //     )
                      // ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
