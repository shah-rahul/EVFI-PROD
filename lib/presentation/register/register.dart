// ignore_for_file: unused_local_variable, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, non_constant_identifier_names, avoid_unnecessary_containers, use_build_context_synchronously

import 'package:evfi/presentation/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../onboarding/onboarding1.dart';
import '../storage/UserDataProvider.dart';
import 'package:page_transition/page_transition.dart';
import '../resources/color_manager.dart';
import '../resources/assets_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/values_manager.dart';
import '../login/signup_controller.dart';

import 'package:get/get.dart';
import '../storage/UserData.dart';

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
    final userDataProvider = Provider.of<UserDataProvider>(context);
    //  Storing user's name  using provider

      
    void StoreName(String name) {
      UserData userData = userDataProvider.userData;
      userData.firstName = name;
      userData.level1 = true;
      
      userDataProvider.setUserData(userData);
    }

    return Container(
      decoration:  const BoxDecoration(
          image:  DecorationImage(
        image:  AssetImage(ImageAssets.loginBackground),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
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
                              onChanged: (value) async {
                                // Store the entered name in the provider
                                setState(() {
                                  nameController.text = value;
                                });


                                //          await userDataProvider.saveUserData();
                                // UserData? userData = userDataProvider.userData;
                                // userDataProvider.setUserData(userData);
                                // // Store the entered phone number in the provider
                                // registerUser(userDataProvider.userData.name,
                                //     widget.phoneNumber);
                              },

                              style: TextStyle(color: ColorManager.darkGrey),
                              //controller: nameController,
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
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () async {
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
                              const SizedBox(
                                width: AppSize.s12,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  StoreName(nameController.text);
                                  await userDataProvider.saveUserData();
                                 
                                  Navigator.push(context, PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        
                                       
                                        // child: OnBoardingView()),
                                        child: const Onboarding1()),
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
                            ],
                          ),
                        ],
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
