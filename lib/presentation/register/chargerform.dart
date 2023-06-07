import 'package:EVFI/presentation/main/main_view.dart';
import 'package:EVFI/presentation/register/vehicleform.dart';
import 'package:EVFI/presentation/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import '../resources/color_manager.dart';
import '../resources/assets_manager.dart';
import '../resources/values_manager.dart';

class ChargerForm extends StatefulWidget {
  const ChargerForm({Key? key}) : super(key: key);

  @override
  _ChargerFormState createState() => _ChargerFormState();
}

class _ChargerFormState extends State<ChargerForm> {
  TextEditingController chargerspeedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FocusNode myfocus = FocusNode();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorManager.appBlack,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: AppSize.s100 + AppSize.s18),
              height: AppSize.s100 + AppSize.s100,
              child: Image.asset(ImageAssets.chargerform),
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
                      AppStrings.chargerformtitle,
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
                          child: DropDownTextField(
                            dropDownItemCount: 3,
                            clearOption: false,
                            dropDownList: const [
                              DropDownValueModel(
                                  name: 'Type A', value: "Type A"),
                              DropDownValueModel(
                                  name: 'Type B', value: "Type B"),
                              DropDownValueModel(
                                  name: 'Type C', value: "Type C"),
                            ],
                            dropdownColor: ColorManager.darkGrey,
                            textFieldDecoration: InputDecoration(
                              hoverColor: ColorManager.primary,
                              iconColor: ColorManager.primary,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: ColorManager.darkGrey,
                                ),
                              ),
                              labelText: 'Charger Type',
                              labelStyle: TextStyle(
                                fontSize: AppSize.s14,
                              ),
                            ),
                            onChanged: (val) {
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppPadding.p8,
                              vertical: AppPadding.p8),
                          child: TextField(
                            controller: chargerspeedController,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: ColorManager.darkGrey,
                                  ),
                                ),
                                labelText: 'Charger Speed',
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: AppSize.s60 - 10,
                              width: width * 0.23,
                              margin: EdgeInsets.only(
                                top: AppMargin.m20,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.leftToRight,
                                          ctx: context,
                                          child: VehicleForm()));
                                  ;
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
                                child: const Text("Back"),
                              ),
                            ),
                            Container(
                              height: AppSize.s60 - 10,
                              width: width * 0.23,
                              margin: EdgeInsets.only(
                                top: AppMargin.m20,
                              ),

                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: MainView()),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 15),
                                  textStyle:
                                      const TextStyle(fontSize: AppSize.s18),
                                ),
                                child: const Text(AppStrings.skip),
                              ),

                              // print(nameController.text);
                              // print(passwordController.text);
                            ),
                            Container(
                              height: AppSize.s60 - 10,
                              width: width * 0.3,
                              margin: EdgeInsets.only(
                                top: AppMargin.m20,
                              ),
                              // padding: const EdgeInsets.only(right: AppPadding.p20),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: MainView()),
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
                                child: const Text("Save"),
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