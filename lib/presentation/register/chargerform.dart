// ignore_for_file: use_build_context_synchronously, unused_element, unused_local_variable, library_private_types_in_public_api, unnecessary_null_comparison

import 'package:evfi/presentation/main/main_view.dart';
import 'package:evfi/presentation/resources/strings_manager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:provider/provider.dart';
import '../Data_storage/UserData.dart';
import '../Data_storage/UserDataProvider.dart';
import '../resources/color_manager.dart';
import '../resources/assets_manager.dart';
import '../resources/values_manager.dart';

class ChargerForm extends StatefulWidget {
  const ChargerForm({Key? key}) : super(key: key);

  @override
  _ChargerFormState createState() => _ChargerFormState();
}

class _ChargerFormState extends State<ChargerForm> {
  String _selectedChargerType = '1';

  TextEditingController chargerspeedController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('Users');
  @override
  Widget build(BuildContext context) {
    //FocusNode myfocus = FocusNode();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final userDataProvider = Provider.of<UserDataProvider>(context);
    void updateChargingData(String type, String speed) {
      UserData userData = userDataProvider.userData;
      // userData.chargingType = type;

      userDataProvider.setUserData(userData);
    }

    final Map<String, String> dropdownItems = {
      '1': 'Level 1',
      '2': 'Level 2 ',
      '3': 'Level 3',
    };

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage(ImageAssets.loginBackground),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
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
                        AppStrings.chargerformtitle,
                        style: TextStyle(
                          fontSize: 24,
                          color: ColorManager.darkGrey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(AppPadding.p20),
                      child: Column(
                        children: [
                          Text('Select Charger Type'),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppPadding.p8,
                                vertical: AppPadding.p8),
                            child: DropdownButton<String>(
                              value: _selectedChargerType,
                              onChanged: (newValue) {
                                setState(() {
                                  print(newValue);
                                  _selectedChargerType = newValue!;
                                });
                              },
                              items: dropdownItems.keys.map((String key) {
                                return DropdownMenuItem<String>(
                                  value: key,
                                  child: Text(
                                    dropdownItems[key]!,
                                    style:
                                        TextStyle(color: ColorManager.darkGrey),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          //controller: chargetypeController,
                          // dropDownItemCount: 3,
                          // clearOption: false,
                          // dropDownList: const [
                          //   DropDownValueModel(
                          //       name: 'Level 1 / Slow', value: 'level1'),
                          //   DropDownValueModel(
                          //       name: 'Level 2 / Fast', value: 'level2'),
                          //   DropDownValueModel(
                          //       name: 'Level 3 / DC Fast', value: 'level3'),
                          // ],
                          //                  onChanged: (value) {
                          //   updateChargingData(value, userDataProvider.userData.chargingSpeed);
                          // },

                          // style:
                          //     TextStyle(color: ColorManager.darkGrey),
                          // dropdownColor: Colors.white,
                          // itemHeight: ,
                          // textFieldDecoration: InputDecoration(
                          //   hoverColor: ColorManager.primary,
                          //   iconColor: ColorManager.primary,
                          //   enabledBorder: UnderlineInputBorder(
                          //     borderSide: BorderSide(
                          //       width: 1,
                          //       color: ColorManager.darkGrey,
                          //     ),
                          //   ),
                          //   labelText: 'Charger Type',
                          //   labelStyle: const TextStyle(
                          //     fontSize: AppSize.s14,
                          //   ),
                          // ),
                          // onChanged: (value) => ,

                          // onChanged: (val) {
                          //   updateChargingData(val.toString(),
                          //      // userDataProvider.userData.chargingType);
                          //   FocusScope.of(context)
                          //       .requestFocus(FocusNode());
                          // },
                          //   ),
                          // ),
                          // Container(
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal: AppPadding.p8,
                          //       vertical: AppPadding.p8),
                          //   child: TextField(
                          //     onChanged: (value) {
                          //       updateChargingData(
                          //           userDataProvider.userData.chargingSpeed,
                          //           value);
                          //     },
                          //     style: TextStyle(color: ColorManager.darkGrey),
                          //     //controller: chargerspeedController,
                          //     decoration: InputDecoration(
                          //         enabledBorder: UnderlineInputBorder(
                          //           borderSide: BorderSide(
                          //             width: 1,
                          //             color: ColorManager.darkGrey,
                          //           ),
                          //         ),
                          //         labelText: 'Charger Speed',
                          //         labelStyle:
                          //             const TextStyle(fontSize: AppSize.s14)),
                          //   ),
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  int count = 0;
                                  // Navigator.of(context)
                                  //     .popUntil((_) => count++ > 3);
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        ctx: context,
                                        child: MainView()),
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
                              const SizedBox(
                                width: AppSize.s12,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  // await userDataProvider.saveUserData();

                                  // Example: Storing charging information
                                  String chargingType = 'Type A';
                                  String chargingSpeed =
                                      chargerspeedController.text.toString();
                                  UserData? userData =
                                      userDataProvider.userData;
                                  userDataProvider.setUserData(userData);

                                  int count = 0;
                                  // Navigator.of(context)
                                  //     .popUntil((_) => count++ > 3);
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: MainView(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shadowColor: Colors.white,
                                  elevation: 6,
                                ),
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    color: ColorManager.appBlack,
                                    fontSize: AppSize.s16,
                                  ),
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
