
import 'package:EVFI/presentation/register/register.dart';
import 'package:EVFI/presentation/resources/strings_manager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../resources/color_manager.dart';
import '../resources/assets_manager.dart';
import './chargerform.dart';

import 'package:page_transition/page_transition.dart';
import '../resources/values_manager.dart';

class VehicleForm extends StatefulWidget {
  // const VehicleForm({Key? key}) : super(key: key);
  final String username;
  final String phoneNumber;
  const VehicleForm({required this.username, required this.phoneNumber});
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
    return Scaffold(
      backgroundColor: ColorManager.appBlack,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: AppSize.s100 + AppSize.s18),
              height: AppSize.s100 + 80,
              child: Image.asset(ImageAssets.vehicleForm),
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
            const SizedBox(
              height: AppSize.s60,
            ),
            Container(
              height: height * 0.7,
              child: ListView(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: AppMargin.m12),
                    child: const Text(
                      AppStrings.vehicleformTitle,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
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
                    margin: const EdgeInsets.symmetric(horizontal: AppMargin.m20),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: ColorManager.darkGreyOpacity40,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          color: ColorManager.darkGrey,
                          offset: const Offset(-1, -1),
                        ),
                        const BoxShadow(
                          blurRadius: 6,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
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
                            controller: vehicleManufacturerController,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: ColorManager.darkGrey,
                                  ),
                                ),
                                labelText: 'Vehicle Manufacturer',
                                labelStyle: const TextStyle(fontSize: AppSize.s14)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppPadding.p8,
                              vertical: AppPadding.p8),
                          child: TextField(
                            controller: vehicleregistrationController,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: ColorManager.darkGrey,
                                  ),
                                ),
                                labelText: 'Vehicle Registration Number',
                                labelStyle: const TextStyle(fontSize: AppSize.s14)),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: AppSize.s60 - 10,
                              width: width * 0.23,
                              margin: const EdgeInsets.only(
                                top: AppMargin.m20,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.leftToRight,
                                          ctx: context,
                                          child: RegisterView(
                                            phoneNumber: '',
                                          )));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      ColorManager.darkGrey.withOpacity(0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  // side: BorderSide(color: Colors.white)),
                                  elevation: 0,

                                  textStyle:
                                      const TextStyle(fontSize: AppSize.s18),
                                ),
                                child: const Text("Back",
                                    textAlign: TextAlign.center),
                              ),
                            ),
                            Container(
                              height: AppSize.s60 - 10,
                              width: width * 0.23,
                              margin: const EdgeInsets.only(
                                top: AppMargin.m20,
                              ),

                              child: ElevatedButton(
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
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        ctx: context,
                                        child: ChargerForm(
                                          username: widget.username,
                                          phoneNumber: widget.phoneNumber,
                                          vehicleManufacturer: vehicleManufacturerController.text
                                             .toString(),
                                          VehicleRegistrationNumber:vehicleregistrationController.text
                                             .toString() ,
                                        )),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      ColorManager.darkGrey.withOpacity(0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  // side: BorderSide(color: Colors.white)),
                                  elevation: 0,

                                  textStyle:
                                      const TextStyle(fontSize: AppSize.s18),
                                ),
                                child: const Text(AppStrings.skip,
                                    textAlign: TextAlign.center),
                              ),

                              // print(nameController.text);
                              // print(passwordController.text);
                            ),
                            Container(
                              height: AppSize.s60 - 10,
                              width: width * 0.3,
                              margin: const EdgeInsets.only(
                                top: AppMargin.m20,
                              ),
                              // padding: const EdgeInsets.only(right: AppPadding.p20),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        ctx: context,
                                        child: ChargerForm( username: widget.username,
                                          phoneNumber: widget.phoneNumber,
                                          vehicleManufacturer: vehicleManufacturerController.text
                                             .toString(),
                                          VehicleRegistrationNumber:vehicleregistrationController.text
                                             .toString() ,)),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      ColorManager.primary.withOpacity(0.9),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 0,
                                  textStyle:
                                      const TextStyle(fontSize: AppSize.s18),
                                ),
                                child: const Text("Save",
                                    textAlign: TextAlign.center),
                              ),

                              // print(nameController.text);
                              // print(passwordController.text);
                            ),
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
    );
  }
}
