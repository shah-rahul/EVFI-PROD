import 'package:EVFI/presentation/main/main_view.dart';
import 'package:EVFI/presentation/register/UserChargingRegister.dart';
import 'package:EVFI/presentation/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Data_storage/UserDataProvider.dart';
import './vehicleform.dart';
import 'package:page_transition/page_transition.dart';
import '../resources/color_manager.dart';
import '../resources/assets_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/values_manager.dart';
import '../login/signup_controller.dart';

import 'package:get/get.dart';
import '../Data_storage/UserData.dart';

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
    // Example: Storing user's name and phone number using provider

    void registerUser(String name, String phoneNumber) {
      UserData userData = UserData(
        name: name,
        phoneNumber: phoneNumber,
        vehicleManufacturer: "",
        vehicleNumber: "",
        chargingType: "",
        chargingSpeed: "",
      );
      userDataProvider.setUserData(userData);
    }

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
                              onChanged: (value) {
                                // Store the entered name in the provider

                                registerUser(value,
                                    userDataProvider.userData.phoneNumber);
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
                                  await userDataProvider.saveUserData();
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
                              SizedBox(
                                width: AppSize.s12,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        // child: VehicleForm()),
                                        child: UserChargingRegister()),
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
