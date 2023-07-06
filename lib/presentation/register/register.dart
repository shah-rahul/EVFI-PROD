import 'package:EVFI/presentation/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import './vehicleform.dart';
import 'package:page_transition/page_transition.dart';
import '../resources/color_manager.dart';
import '../resources/assets_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/values_manager.dart';
import '../login/signup_controller.dart';

import 'package:get/get.dart';
import '../Data_storage/api.dart';

class RegisterView extends StatefulWidget {
  // const RegisterView({
  //   Key? key,
  // }) : super(key: key);
  final String phoneNumber;
  RegisterView({
    required this.phoneNumber,
  });

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController nameController = TextEditingController();
  // String phoneNumber = "";
  bool loading = false;
  //Reference for firebase realtime database name as user
  //final databaseRef = FirebaseDatabase.instance.ref('user');
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
            children: [
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

              Container(
                height: height * 0.46,
                margin: EdgeInsets.only(
                    top: height * 0.48,
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
                    ]),
                child: ListView(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: height * 0.02),
                      alignment: Alignment.center,
                      // margin: const EdgeInsets.only(left: AppMargin.m12),
                      child: Text(
                        AppStrings.registertitle,
                        style: TextStyle(
                          fontSize: 24,
                          color: ColorManager.darkGrey,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        AppStrings.registertitle2,
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorManager.darkGrey,
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.symmetric(horizontal: AppMargin.m20),
                      padding: const EdgeInsets.all(AppPadding.p20),
                      child: Column(
                        children: [
                          GestureDetector(
                            child: Container(
                              child: Image.asset(ImageAssets.registerDp,
                                  height: height * 0.12,
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
                              style: TextStyle(color: ColorManager.darkGrey),
                              controller: nameController,
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: ColorManager.darkGrey,
                                    ),
                                  ),
                                  labelText: 'User Name',
                                  labelStyle:
                                      const TextStyle(fontSize: AppSize.s14)),
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
                          const SizedBox(
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
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Routes.loginRoute);
                                },
                                child: Text(
                                  AppStrings.registercancel,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: ColorManager.darkGrey,
                                      fontSize: AppSize.s16),
                                ),
                              ),

                              // print(nameController.text);
                              // print(passwordController.text);
                              SizedBox(
                                width: AppSize.s12,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // final user = UserModel(
                                  //     fullName: nameController.text.trim(),
                                  //     phoneNo: phoneNumber);
                                  // var phoneController;
                                  // Generate a unique key for each user
                                  // void _getPhoneNumber(String phoneNumber) {
                                  //   this.phoneNumber;
                                  // }

                                  // var userKey =
                                  //     databaseRef.child('user').push().key;

                                  // Create a new user object
                                  // var newUser = {
                                  //   'name': nameController.text.toString(),
                                  //   'phone': widget.phoneNumber,
                                  // };
                                  // Add the new user under the unique key
                                  // databaseRef
                                  //     .child('users/$userKey')
                                  //     .set(newUser)
                                  //     .then((value) {
                                  // Code to execute after the data is successfully saved.
                                  //   print('User added successfully!');
                                  // }).catchError((error) {
                                  // Code to handle any errors that occurred during the data saving process.
                                  //   print('Error adding user: $error');
                                  // });
                                  // databaseRef.set({
                                  //   'name': nameController.text.toString(),
                                  //   'phone': phoneNumber,
                                  // }).then((value) {
                                  // Code to execute after the data is successfully saved.
                                  //   print('Data saved successfully!');
                                  // }).catchError((error) {
                                  // Code to handle any errors that occurred during the data saving process.
                                  //   print('Error saving data: $error');
                                  // });
                                  // SignUpController.instance.createUser(user);
                                  Api.storeUserName(
                                    name: nameController.text.toString(),
                                  );
                                  Api.storeUserPhone(
                                    phoneNumber: widget.phoneNumber,
                                  );

                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: VehicleForm(
                                          
                                        )),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shadowColor: Colors.white,
                                    elevation: 6),
                                child: Text(
                                  AppStrings.registerSignup,
                                  style: TextStyle(
                                      color: ColorManager.appBlack,
                                      fontSize: AppSize.s16),
                                ),
                              ),

                              // print(nameController.text);
                              // print(passwordController.text);
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
      ),
    );
  }
}
