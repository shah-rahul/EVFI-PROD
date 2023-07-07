import 'package:EVFI/presentation/register/register.dart';
import 'package:EVFI/presentation/resources/strings_manager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../Data_storage/api.dart';
import '../resources/color_manager.dart';
import '../resources/assets_manager.dart';
import './chargerform.dart';

import 'package:page_transition/page_transition.dart';
import '../resources/values_manager.dart';

class VehicleForm extends StatefulWidget {
  const VehicleForm({Key? key}) : super(key: key);

  @override
  _VehicleFormState createState() => _VehicleFormState();
}

class _VehicleFormState extends State<VehicleForm> {
  TextEditingController vehicleManufacturerController = TextEditingController();
  TextEditingController vehicleregistrationController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('user');
  @override
  Widget build(BuildContext context) {
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
                height: height * 0.38,
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
                      child: Text(
                        AppStrings.vehicleformTitle,
                        style: TextStyle(
                          fontSize: 24,
                          color: ColorManager.darkGrey,
                        ),
                      ),
                    ),
                    // Container(
                    //   alignment: Alignment.center,
                    //   margin: EdgeInsets.only(left: AppMargin.m12),
                    //   padding: const EdgeInsets.all(10),
                    //   child: Text(
                    //     'Create your Account',
                    //     style: TextStyle(
                    //       fontSize: 14,
                    //       color: ColorManager.primary,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(AppPadding.p20),
                      child: Column(
                        children: [
                          // child: CircleAvatar(
                          //   backgroundColor: ColorManager.primary,
                          //   radius: 42,
                          //   child: CircleAvatar(
                          //     radius: 50,
                          //     backgroundImage:
                          //         AssetImage(ImageAssets.registerDp),
                          //   ),
                          // ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppPadding.p8,
                                vertical: AppPadding.p8),
                            child: TextField(
                              style: TextStyle(color: ColorManager.darkGrey),
                              controller: vehicleManufacturerController,
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: ColorManager.darkGrey,
                                    ),
                                  ),
                                  labelText: 'Vehicle Manufacturer',
                                  labelStyle:
                                      const TextStyle(fontSize: AppSize.s14)),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppPadding.p8,
                                vertical: AppPadding.p8),
                            child: TextField(
                              style: TextStyle(color: ColorManager.darkGrey),
                              controller: vehicleregistrationController,
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: ColorManager.darkGrey,
                                    ),
                                  ),
                                  labelText: 'Vehicle Registration Number',
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
                                  // var userKey =
                                  //     databaseRef.child('user').push().key;
                                  // var newUser = {
                                  //   'vehicle_manufacturer':
                                  //       vehicleManufacturerController.text
                                  //           .toString(),
                                  //   'vehicle registration number':
                                  //       vehicleregistrationController.text
                                  //           .toString(),
                                  // };
                                  // databaseRef
                                  //     .child('users/$userKey')
                                  //     .set(newUser)
                                  //     .then((value) {
                                  //   // Code to execute after the data is successfully saved.
                                  //   print('User added successfully!');
                                  // }).catchError((error) {
                                  //   // Code to handle any errors that occurred during the data saving process.
                                  //   print('Error adding user: $error');
                                  // });
                                  Api.storeVehicleManufacturer(
                                    vehicleManufacturer: vehicleManufacturerController.text
                                                  .toString(),
                                  );

                                  Api.storeVehicleNumber(
                                    vehicleNumber: vehicleregistrationController.text
                                                  .toString(),
                                  );
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        ctx: context,
                                        child: ChargerForm(
                                          
                                        )),
                                  );
                                },
                                child: Text(
                                  AppStrings.skip,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: ColorManager.darkGrey,
                                      fontSize: AppSize.s16),
                                ),
                              ),

                              // print(nameController.text);
                              // print(passwordController.text);

                              const SizedBox(
                                width: AppSize.s12,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        ctx: context,
                                        child: ChargerForm(
                                          
                                        )),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shadowColor: Colors.white,
                                    elevation: 6),
                                child: Text(
                                  "Save",
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
                      ),
                    ),

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
