// ignore_for_file: library_private_types_in_public_api, unused_local_variable, unnecessary_null_comparison, use_build_context_synchronously

import 'package:evfi/presentation/resources/strings_manager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Data_storage/UserData.dart';
import '../Data_storage/UserDataProvider.dart';
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
  TextEditingController vehicleBatteryCapController = TextEditingController();
  TextEditingController vehicleMileageController = TextEditingController();
  final FocusNode vehicleManfFocus = new FocusNode();
  final FocusNode vehicleregisFocus = new FocusNode();
  final FocusNode vehicleBatteryFocus = new FocusNode();
  final FocusNode vehicleMileageFocus = new FocusNode();
  final databaseRef = FirebaseDatabase.instance.ref('user');

  TextInputType getKeyboard(FocusNode fn) {
    if (fn == vehicleManfFocus || fn == vehicleregisFocus) {
      return TextInputType.emailAddress;
    }
    return TextInputType.number;
  }

  Widget constructTextField(
      String label,
      Function onChanged,
      TextEditingController controller,
      FocusNode focusNode,
      FocusNode nextFocus) {
    return TextField(
      onChanged: (value) {
        onChanged(value);
      },
      keyboardType: getKeyboard(focusNode),
      style: TextStyle(color: ColorManager.darkGrey),
      controller: controller,
      focusNode: focusNode,
      onSubmitted: (value) {
        FocusScope.of(context).requestFocus(nextFocus);
        if (focusNode == vehicleMileageFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      // controller: vehicleregistrationController,
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: ColorManager.darkGrey,
            ),
          ),
          labelText: label,
          labelStyle: const TextStyle(fontSize: AppSize.s14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final userDataProvider = Provider.of<UserDataProvider>(context);

    void updateVehicleData(String manufacturer, String number) {
      UserData userData = userDataProvider.userData;
      userData.vehicleManufacturer = manufacturer;
      userData.vehicleRegistrationNumber = number;
      userDataProvider.setUserData(userData);
    }

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
                height: height * 0.48,
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
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(AppPadding.p20),
                      child: Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppPadding.p8,
                                  vertical: AppPadding.p8),
                              child: constructTextField(
                                  "Vehicle Manufacturer",
                                  (val) {},
                                  vehicleManufacturerController,
                                  vehicleManfFocus,
                                  vehicleregisFocus)),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppPadding.p8,
                                  vertical: AppPadding.p8),
                              child: constructTextField(
                                  "Vehicle Registration",
                                  (val) {},
                                  vehicleregistrationController,
                                  vehicleregisFocus,
                                  vehicleBatteryFocus)),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppPadding.p8,
                                  vertical: AppPadding.p8),
                              child: constructTextField(
                                  "Battery capacity",
                                  (val) {},
                                  vehicleBatteryCapController,
                                  vehicleBatteryFocus,
                                  vehicleMileageFocus)),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppPadding.p8,
                                  vertical: AppPadding.p8),
                              child: constructTextField(
                                  "Vehicle Mileage (Range)",
                                  (val) {},
                                  vehicleMileageController,
                                  vehicleMileageFocus,
                                  vehicleMileageFocus)),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  //skip button section

                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        ctx: context,
                                        child: const ChargerForm()),
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
                                  updateVehicleData(
                                      vehicleManufacturerController.text,
                                      vehicleregistrationController.text);

                                  UserData? userData =
                                      userDataProvider.userData;
                                  userDataProvider.setUserData(userData);

                                  await userDataProvider.updateUserData();

                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        ctx: context,
                                        child: const ChargerForm()),
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
