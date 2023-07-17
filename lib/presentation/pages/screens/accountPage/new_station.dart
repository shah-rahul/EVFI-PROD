//To add a new station in firestore

import 'dart:ffi';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/my_charging.dart';
import '../../../resources/color_manager.dart';
import '../../models/encode_geohash.dart';

class NewStation extends StatefulWidget {
  const NewStation({Key? key}) : super(key: key);

  @override
  State<NewStation> createState() => _NewStationState();
}

class _NewStationState extends State<NewStation> {
  LatLng? coordinate;
  double? latitude;
  double? longitude;
  String? Chargername;

  final _longitudeFocusNode = FocusNode();
  final _latitudeFocusNode = FocusNode();

  final _typeFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  late SingleValueDropDownController _cnt;
  typeCharger? type = typeCharger.Level1;

  @override
  void initState() {
    _cnt = SingleValueDropDownController();
    super.initState();
  }

  void _addInFirestore() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    print("****");
    _form.currentState!.save();
    String geohash = encodeGeohash(latitude!, longitude!, precision: 9);
    GeoPoint coordinate = GeoPoint(latitude!, longitude!);
    var marker = <String, dynamic>{
      'geo': <String, dynamic>{'geohash': geohash, 'geopoint': coordinate},
      'info': <String, dynamic>{
        'name': Chargername!,
        'type': type?.index.toString()
      }
    };
    await FirebaseFirestore.instance
        .collection('Chargers')
        .add(marker)
        .then((_) => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 25.0,
          right: 25.0,
          left: 25.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10),
      child: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.43,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      return null;
                    }
                    return 'Enter Name of Charger';
                  },
                  style: TextStyle(color: ColorManager.appBlack),
                  decoration: const InputDecoration(labelText: 'Name'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_typeFocusNode),
                  onSaved: (newValue) {
                    setState(() {
                      Chargername = (newValue!);
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Charger Type',
                      ),
                      Row(
                        children: <Widget>[
                          Row(
                            children: [
                              Radio<typeCharger>(
                                value: typeCharger.Level1,
                                groupValue: type,
                                onChanged: (typeCharger? value) {
                                  setState(() {
                                    type = value;
                                  });
                                },
                              ),
                              const Text(
                                'Level 1',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Radio<typeCharger>(
                                value: typeCharger.Level2,
                                groupValue: type,
                                onChanged: (typeCharger? value) {
                                  setState(() {
                                    print("*************");
                                    print(value);
                                    type = value;
                                  });
                                },
                              ),
                              const Text(
                                'Level 2',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Radio<typeCharger>(
                                value: typeCharger.Level3,
                                groupValue: type,
                                onChanged: (typeCharger? value) {
                                  setState(() {
                                    type = value;
                                  });
                                },
                              ),
                              const Text(
                                'Level 3',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // DropDownTextField(
                //   //controller: chargetypeController,
                //   dropDownItemCount: 3,
                //   controller: _cnt,

                //   clearOption: false,
                //   dropDownList: const [
                //     DropDownValueModel(name: 'Level 1 / Slow', value: '0'),
                //     DropDownValueModel(name: 'Level 2 / Fast', value: '1'),
                //     DropDownValueModel(name: 'Level 3 / DC Fast', value: '2'),
                //   ],
                //   //                  onChanged: (value) {
                //   //   updateChargingData(value, userDataProvider.userData.chargingSpeed);
                //   // },
                //   listTextStyle: TextStyle(color: ColorManager.darkGrey),
                //   dropdownColor: Colors.white,
                //   textFieldDecoration: InputDecoration(
                //     hoverColor: ColorManager.primary,
                //     iconColor: ColorManager.primary,
                //     enabledBorder: UnderlineInputBorder(
                //       borderSide: BorderSide(
                //         width: 1,
                //         color: ColorManager.darkGrey,
                //       ),
                //     ),
                //     labelText: 'Charger Type',
                //   ),

                //   onChanged: (val) {
                //     setState(() {
                //       Chargertype = val as String;
                //     });

                //     print(Chargertype);

                //     FocusScope.of(context).requestFocus(_latitudeFocusNode);
                //   },
                // ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      return null;
                    }
                    return 'Please Enter latitude';
                  },
                  style: TextStyle(color: ColorManager.appBlack),
                  decoration: const InputDecoration(labelText: 'Latitude'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_longitudeFocusNode),
                  onSaved: (newValue) {
                    setState(() {
                      latitude = double.parse(newValue!);
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      return null;
                    }
                    return 'Please Enter longitude';
                  },
                  style: TextStyle(color: ColorManager.appBlack),
                  decoration: const InputDecoration(labelText: 'Longitude'),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  focusNode: _longitudeFocusNode,
                  onFieldSubmitted: (_) {
                    _addInFirestore();
                  },
                  onSaved: (newValue) {
                    setState(() {
                      longitude = double.parse(newValue!);
                    });
                  },
                ),
                // Container(
                //   margin: const EdgeInsets.all(10),
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //         side: const BorderSide(width: 1, color: Colors.black),
                //         backgroundColor: ColorManager.primary),
                //     onPressed: () {
                //       _addInFirestore;
                //     },
                //     child: Text(
                //       'Add',
                //       style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 16,
                //         color: ColorManager.appBlack,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
