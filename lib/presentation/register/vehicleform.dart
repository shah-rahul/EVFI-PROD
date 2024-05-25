// ignore_for_file: library_private_types_in_public_api, unused_local_variable, unnecessary_null_comparison, use_build_context_synchronously

import 'package:evfi/presentation/resources/strings_manager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main/main_view.dart';
import '../resources/font_manager.dart';
import '../storage/UserData.dart';
import '../storage/UserDataProvider.dart';
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
  String chargingRequirement = '';
  bool isFormValid = false;
  String _selectedChargerType = '1';

  bool isVehicleManufacturerValid = true;
  bool isVehicleRegistrationValid = true;
  bool isVehicleBatteryCapValid = true;
  bool isVehicleMileageValid = true;

  final FocusNode vehicleManfFocus = new FocusNode();
  final FocusNode vehicleregisFocus = new FocusNode();
  final FocusNode vehicleBatteryFocus = new FocusNode();
  final FocusNode vehicleMileageFocus = new FocusNode();
  final FocusNode chargingRequirementFocus = new FocusNode();
  final databaseRef = FirebaseDatabase.instance.ref('user');

  TextInputType getKeyboard(FocusNode fn) {
    if (fn == vehicleManfFocus || fn == vehicleregisFocus) {
      return TextInputType.emailAddress;
    }
    return TextInputType.number;
  }

  void validateForm() {
    setState(() {
      isVehicleManufacturerValid = vehicleManufacturerController.text.isNotEmpty;
      isVehicleRegistrationValid = vehicleregistrationController.text.isNotEmpty;
      isVehicleBatteryCapValid = vehicleBatteryCapController.text.isNotEmpty;
      isVehicleMileageValid = vehicleMileageController.text.isNotEmpty;

      isFormValid = isVehicleManufacturerValid &&
          isVehicleRegistrationValid &&
          isVehicleBatteryCapValid &&
          isVehicleMileageValid;
    });
  }
  Widget constructTextField(
      String label,
      String description,
      TextEditingController controller,
      FocusNode focusNode,
      FocusNode nextFocus,
      bool isValid) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: height * 0.018,color: ColorManager.primary),
            ),
            IconButton(
              icon: Icon(Icons.info_outline, color: ColorManager.primary, size: height * 0.025),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(label),
                      content: Text(description),
                      actions: [
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        SizedBox(height: height * 0.01),
        TextField(
          onChanged: (value) {
            validateForm();
          },
          keyboardType: getKeyboard(focusNode),
          style: TextStyle(color: ColorManager.primary),
          controller: controller,
          focusNode: focusNode,
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(nextFocus);
            if (focusNode == vehicleMileageFocus) {
              FocusScope.of(context).unfocus();
            }
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: ColorManager.greyText,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                width: 1,
                color: ColorManager.greyText,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                width: 2,
                color: ColorManager.greyText,
              ),
            ),
          ),
        ),
        if (!isValid)
          Padding(
            padding: EdgeInsets.only(top: height * 0.01),
            child: Text(
              AppStrings.errorMessage,
              style: TextStyle(color: ColorManager.error, fontSize: AppSize.s12),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final userDataProvider = Provider.of<UserDataProvider>(context);

    void updateVehicleData(String manufacturer, String number,
        String batteryCapacity, String mileage, String chargingRequirements) {
      UserData userData = userDataProvider.userData;
      userData.vehicleManufacturer = manufacturer;
      userData.vehicleRegistrationNumber = number;
      userData.batteryCapacity = batteryCapacity;
      userData.mileage = mileage;
      userData.level2 = true;
      userDataProvider.setLevel2();
      userDataProvider.setUserData(userData);
    }

    final Map<String, String> dropdownItems = {
      '1': 'Level 1',
      '2': 'Level 2',
      '3': 'Level 3',
    };

    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: height * 0.05,
                right: width * 0.05,
                bottom: height * 0.03,
                left: width * 0.05,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.vehicleformTitle,
                        style: TextStyle(
                          fontSize: height * 0.04,
                          fontFamily: FontConstants.appTitleFontFamily,
                          color: ColorManager.appBlack,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        AppStrings.vehicleformSubTitle,
                        style: TextStyle(
                          fontSize: height * 0.02,
                          color: ColorManager.appBlack,
                          fontWeight: FontWeightManager.regular
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    ImageAssets.splashlogo,
                    height: height * 0.08,
                    width: height * 0.08,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              padding: EdgeInsets.all(height * 0.025),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(37),
                  topRight: Radius.circular(37),
                ),
                color: ColorManager.appBlack,
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
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: height * 0.025),
                  constructTextField(
                    "Vehicle Manufacturer",
                    "Enter the manufacturer of your vehicle",
                    vehicleManufacturerController,
                    vehicleManfFocus,
                    vehicleregisFocus,
                      isVehicleManufacturerValid
                  ),
                  SizedBox(height: height * 0.025),
                  constructTextField(
                    "Vehicle Registration",
                    "Enter the registration number of your vehicle",
                    vehicleregistrationController,
                    vehicleregisFocus,
                    vehicleBatteryFocus,
                      isVehicleRegistrationValid
                  ),
                  SizedBox(height: height * 0.025),
                  constructTextField(
                    "Battery Capacity",
                    "Enter the battery capacity of your vehicle in kWh",
                    vehicleBatteryCapController,
                    vehicleBatteryFocus,
                    vehicleMileageFocus,
                      isVehicleBatteryCapValid
                  ),
                  SizedBox(height: height * 0.025),
                  constructTextField(
                    "Vehicle Mileage",
                    "Enter the mileage or range of your vehicle in miles",
                    vehicleMileageController,
                    vehicleMileageFocus,
                    vehicleMileageFocus,
                      isVehicleMileageValid
                  ),
                  SizedBox(height: height * 0.025),
                  Row(
                    children: [
                      Text(
                        'Select Charger Type',
                        style: TextStyle(fontSize: height * 0.018,color: ColorManager.primary),
                      ),
                      IconButton(
                        icon: Icon(Icons.info_outline, color: ColorManager.primary, size: height * 0.025),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Charger Type'),
                                content: Text('Choose anyone from Level 1, Level 2, Level 3'),
                                actions: [
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  Container(
                    // padding: const EdgeInsets.symmetric(
                    //     horizontal: AppPadding.p8,
                    //     vertical: AppPadding.p4),
                    decoration: BoxDecoration(
                      color: ColorManager.greyText,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: ColorManager.greyText,
                      ),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: AppPadding.p8),
                        ),
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
                              style: TextStyle(color: ColorManager.primary),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          updateVehicleData(
                              vehicleManufacturerController.text,
                              vehicleregistrationController.text,
                              vehicleBatteryCapController.text,
                              vehicleMileageController.text,
                              chargingRequirement);

                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: MainView(),
                            ),
                          );
                        },
                        child: Text(
                          AppStrings.skip,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorManager.white,
                              fontSize: AppSize.s16,
                              fontWeight: FontWeightManager.regular
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.greyText,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.03,
                      ),
                      ElevatedButton(
                        onPressed: isFormValid
                            ? () {
                          updateVehicleData(
                              vehicleManufacturerController.text,
                              vehicleregistrationController.text,
                              vehicleBatteryCapController.text,
                              vehicleMileageController.text,
                              chargingRequirement);

                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: MainView(),
                            ),
                          );
                        }
                            : () {
                          validateForm();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Save",
                          style: TextStyle(
                              color: ColorManager.appBlack,
                              fontSize: height * 0.02),
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
    );
  }
}

// // ignore_for_file: library_private_types_in_public_api, unused_local_variable, unnecessary_null_comparison, use_build_context_synchronously
//
// import 'package:evfi/presentation/resources/strings_manager.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../storage/UserData.dart';
// import '../storage/UserDataProvider.dart';
// import '../resources/color_manager.dart';
// import '../resources/assets_manager.dart';
// import './chargerform.dart';
//
// import 'package:page_transition/page_transition.dart';
// import '../resources/values_manager.dart';
//
// class VehicleForm extends StatefulWidget {
//   const VehicleForm({Key? key}) : super(key: key);
//
//   @override
//   _VehicleFormState createState() => _VehicleFormState();
// }
//
// class _VehicleFormState extends State<VehicleForm> {
//   TextEditingController vehicleManufacturerController = TextEditingController();
//   TextEditingController vehicleregistrationController = TextEditingController();
//   TextEditingController vehicleBatteryCapController = TextEditingController();
//   TextEditingController vehicleMileageController = TextEditingController();
//   String chargingRequirement = '';
//
//   final FocusNode vehicleManfFocus = new FocusNode();
//   final FocusNode vehicleregisFocus = new FocusNode();
//   final FocusNode vehicleBatteryFocus = new FocusNode();
//   final FocusNode vehicleMileageFocus = new FocusNode();
//   final FocusNode chargingRequirementFocus = new FocusNode();
//   final databaseRef = FirebaseDatabase.instance.ref('user');
//
//   TextInputType getKeyboard(FocusNode fn) {
//     if (fn == vehicleManfFocus || fn == vehicleregisFocus) {
//       return TextInputType.emailAddress;
//     }
//     return TextInputType.number;
//   }
//
//   Widget constructTextField(
//       String label,
//       Function onChanged,
//       TextEditingController controller,
//       FocusNode focusNode,
//       FocusNode nextFocus) {
//     return TextField(
//       onChanged: (value) {
//         onChanged(value);
//       },
//       keyboardType: getKeyboard(focusNode),
//       style: TextStyle(color: ColorManager.darkGrey),
//       controller: controller,
//       focusNode: focusNode,
//       onSubmitted: (value) {
//         FocusScope.of(context).requestFocus(nextFocus);
//         if (focusNode == vehicleMileageFocus) {
//           FocusScope.of(context).unfocus();
//         }
//       },
//       decoration: InputDecoration(
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(
//               width: 1,
//               color: ColorManager.darkGrey,
//             ),
//           ),
//           labelText: label,
//           labelStyle: const TextStyle(fontSize: AppSize.s14)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     final userDataProvider = Provider.of<UserDataProvider>(context);
//
//     void updateVehicleData(String manufacturer, String number,
//         String batteryCapacity, String mileage, String chargingRequirements) {
//       UserData userData = userDataProvider.userData;
//       userData.vehicleManufacturer = manufacturer;
//       userData.vehicleRegistrationNumber = number;
//       userData.batteryCapacity = batteryCapacity;
//       userData.mileage = mileage;
//       userData.level2 = true;
//       userDataProvider.setLevel2();
//       userDataProvider.setUserData(userData);
//     }
//
//     return Container(
//       decoration: const BoxDecoration(
//           image: DecorationImage(
//         image: AssetImage(ImageAssets.loginBackground),
//         fit: BoxFit.cover,
//       )),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 height: height * 0.48,
//                 margin: EdgeInsets.only(
//                     top: height * 0.48,
//                     left: AppMargin.m14,
//                     right: AppMargin.m14),
//                 decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.all(Radius.circular(20)),
//                     color: Colors.white.withOpacity(0.90),
//                     boxShadow: [
//                       BoxShadow(
//                         blurRadius: 2,
//                         color: ColorManager.shadowBottomRight.withOpacity(0.3),
//                         offset: const Offset(4, 4),
//                       ),
//                       BoxShadow(
//                         blurRadius: 2,
//                         color: ColorManager.shadowTopLeft.withOpacity(0.4),
//                         offset: const Offset(2, 2),
//                       ),
//                     ]),
//                 child: ListView(
//                   children: <Widget>[
//                     Container(
//                       margin: EdgeInsets.only(top: height * 0.02),
//                       alignment: Alignment.center,
//                       child: Text(
//                         AppStrings.vehicleformTitle,
//                         style: TextStyle(
//                           fontSize: 24,
//                           color: ColorManager.darkGrey,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Container(
//                       padding: const EdgeInsets.all(AppPadding.p20),
//                       child: Column(
//                         children: [
//                           Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: AppPadding.p8,
//                                   vertical: AppPadding.p8),
//                               child: constructTextField(
//                                   "Vehicle Manufacturer",
//                                   (val) {},
//                                   vehicleManufacturerController,
//                                   vehicleManfFocus,
//                                   vehicleregisFocus)),
//                           Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: AppPadding.p8,
//                                   vertical: AppPadding.p8),
//                               child: constructTextField(
//                                   "Vehicle Registration",
//                                   (val) {},
//                                   vehicleregistrationController,
//                                   vehicleregisFocus,
//                                   vehicleBatteryFocus)),
//                           Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: AppPadding.p8,
//                                   vertical: AppPadding.p8),
//                               child: constructTextField(
//                                   "Battery capacity",
//                                   (val) {},
//                                   vehicleBatteryCapController,
//                                   vehicleBatteryFocus,
//                                   vehicleMileageFocus)),
//                           Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: AppPadding.p8,
//                                   vertical: AppPadding.p8),
//                               child: constructTextField(
//                                   "Vehicle Mileage (Range)",
//                                   (val) {},
//                                   vehicleMileageController,
//                                   vehicleMileageFocus,
//                                   vehicleMileageFocus)),
//                           // Container(
//                           //   padding: const EdgeInsets.symmetric(
//                           //       horizontal: AppPadding.p8,
//                           //       vertical: AppPadding.p8),
//                           //   child: DropdownButton<String>(
//                           //     hint: Text('Charging Requirement'),
//                           //     value: chargingRequirement,
//                           //     onChanged: (value) => setState(() {
//                           //       chargingRequirement = value!;
//                           //     }),
//                           //     items: <String>[
//                           //       'Level 1',
//                           //       'Level 2',
//                           //       'Level 3'
//                           //     ].map<DropdownMenuItem<String>>((String value) {
//                           //       return DropdownMenuItem<String>(
//                           //         value: value,
//                           //         child: Text(value),
//                           //       );
//                           //     }).toList(),
//                           //   ),
//                           // ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               TextButton(
//                                 onPressed: () async {
//                                   updateVehicleData(
//                                       vehicleManufacturerController.text,
//                                       vehicleregistrationController.text,
//                                       vehicleBatteryCapController.text,
//                                       vehicleMileageController.text,
//                                       chargingRequirement);
//                                   //skip button section
//
//                                   Navigator.push(
//                                     context,
//                                     PageTransition(
//                                         type: PageTransitionType.rightToLeft,
//                                         ctx: context,
//                                         child: const ChargerForm()),
//                                   );
//                                 },
//                                 child: Text(
//                                   AppStrings.skip,
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       color: ColorManager.darkGrey,
//                                       fontSize: AppSize.s16),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: AppSize.s12,
//                               ),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   updateVehicleData(
//                                       vehicleManufacturerController.text,
//                                       vehicleregistrationController.text,
//                                       vehicleBatteryCapController.text,
//                                       vehicleMileageController.text,
//                                       chargingRequirement);
//
//                                   Navigator.push(
//                                     context,
//                                     PageTransition(
//                                         type: PageTransitionType.rightToLeft,
//                                         ctx: context,
//                                         child: const ChargerForm()),
//                                   );
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.white,
//                                     shadowColor: Colors.white,
//                                     elevation: 6),
//                                 child: Text(
//                                   "Save",
//                                   style: TextStyle(
//                                       color: ColorManager.appBlack,
//                                       fontSize: AppSize.s16),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
