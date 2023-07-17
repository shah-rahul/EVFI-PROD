import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../../resources/color_manager.dart';
import '../../models/my_charging.dart';
import 'chargers_data.dart';
import 'package:EVFI/presentation/pages/models/header_ui.dart';
import 'package:EVFI/presentation/pages/screens/mycharging/MyChargingScreen.dart';
import 'package:EVFI/presentation/resources/assets_manager.dart';

class ListCharger extends StatefulWidget {
  const ListCharger({Key? key}) : super(key: key);

  @override
  State<ListCharger> createState() => _ListChargerState();
}

class _ListChargerState extends State<ListCharger> {
  Chargers charger = Chargers();

  final _saveForm = GlobalKey<FormState>();
  final _priceFocusNode = FocusNode();
  final _aadharFocusNode = FocusNode();
  final _hostsFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _latFocusNode = FocusNode();
  final _longFocusNode = FocusNode();
  final _amenitiesFocusNode = FocusNode();

  String? StationName, StationAddress, aadharNumber;
  String? hostNames, amenities; //later define hosts as list<string>
  double? amount, latitude, longitude;

  var _isLoading = false;
  typeCharger? _type;

  void _submitForm() async {
    final isValid = _saveForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    _saveForm.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    LatLng coordinates = LatLng(latitude!, longitude!);
    await charger.addCharger(
        StationAddress: StationAddress!,
        StationName: StationName!,
        amount: amount!,
        position: coordinates);

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop(PageTransition(
        type: PageTransitionType.fade, child: const MyChargingScreen()));
  }

  Widget _makeChargerOptions() {
    return Row(
      children: <Widget>[
        Expanded(
            child: RadioListTile<typeCharger>(
          contentPadding: const EdgeInsets.all(0.0),
          value: typeCharger.Level1,
          groupValue: _type,
          tileColor: ColorManager.primary.withOpacity(0.17),
          onChanged: (val) {
            setState(() {
              print('Selected Charger: \t$val');
              _type = val;
            });
          },
          title: const Text(
            'Level1',
            style: TextStyle(color: Colors.black87),
          ),
        )),
        const SizedBox(width: 8),
        Expanded(
            child: RadioListTile<typeCharger>(
          contentPadding: const EdgeInsets.all(0.0),
          value: typeCharger.Level2,
          groupValue: _type,
          tileColor: ColorManager.primary.withOpacity(0.17),
          onChanged: (val) {
            setState(() {
              print('Selected Charger: \t$val');
              _type = val;
            });
          },
          title: const Text(
            'Level2',
            style: TextStyle(color: Colors.black87),
          ),
        )),
        const SizedBox(width: 8),
        Expanded(
            child: RadioListTile<typeCharger>(
          contentPadding: const EdgeInsets.all(0.0),
          value: typeCharger.Level3,
          groupValue: _type,
          tileColor: ColorManager.primary.withOpacity(0.17),
          onChanged: (val) {
            setState(() {
              print('Selected Charger: \t$val');
              _type = val;
            });
          },
          title: const Text(
            'Level3',
            style: TextStyle(color: Colors.black87),
          ),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.white,
          ),
          title: const Text(
            'Rent your Charger',
          ),
          backgroundColor: ColorManager.appBlack,
        ),
        backgroundColor: Colors.grey[200],
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _saveForm,
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: 220,
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 15),
                      child:
                          const HeaderUI(220, true, ImageAssets.oldBlackMarker),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Station Name',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a valid station name.';
                                }
                                return null;
                              },
                              style: TextStyle(color: ColorManager.darkGrey),
                              decoration: const InputDecoration(
                                  hintText: 'Amog Public Battery Station',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_addressFocusNode),
                              onSaved: (newValue) {
                                setState(() {
                                  StationName = newValue!;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text('Address',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a valid address.';
                                }
                                return null;
                              },
                              style: TextStyle(color: ColorManager.darkGrey),
                              decoration: const InputDecoration(
                                  hintText: 'Thannesar Road, Kurukshetra',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                              maxLines: 3,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.next,
                              focusNode: _addressFocusNode,
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_latFocusNode),
                              onSaved: (newValue) {
                                setState(() {
                                  StationAddress = newValue!;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter a valid Latitude.';
                                      }
                                      return null;
                                    },
                                    style:
                                        TextStyle(color: ColorManager.darkGrey),
                                    decoration: const InputDecoration(
                                        labelText: 'Station Latitude',
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        )),
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    focusNode: _latFocusNode,
                                    onFieldSubmitted: (_) =>
                                        FocusScope.of(context)
                                            .requestFocus(_longFocusNode),
                                    onSaved: (newValue) {
                                      setState(() {
                                        latitude = double.parse(newValue!);
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter a valid Longitude.';
                                      }
                                      return null;
                                    },
                                    style:
                                        TextStyle(color: ColorManager.darkGrey),
                                    decoration: const InputDecoration(
                                        labelText: 'Station Longitude',
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        )),
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    focusNode: _longFocusNode,
                                    onFieldSubmitted: (_) =>
                                        FocusScope.of(context)
                                            .requestFocus(_aadharFocusNode),
                                    onSaved: (newValue) {
                                      setState(() {
                                        longitude = double.parse(newValue!);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text('Aadhar No.',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a valid aadhar number.';
                                }
                                return null;
                              },
                              style: TextStyle(color: ColorManager.darkGrey),
                              decoration: const InputDecoration(
                                  hintText: 'XXXX-XXXX-XXXX-XXXX',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                              focusNode: _aadharFocusNode,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_hostsFocusNode),
                              onSaved: (newValue) {
                                aadharNumber = newValue!;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text('Host Names',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter valid names.';
                                }
                                return null;
                              },
                              style: TextStyle(color: ColorManager.darkGrey),
                              decoration: const InputDecoration(
                                  hintText: 'Persons available',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                              maxLines: 3,
                              keyboardType: TextInputType.name,
                              focusNode: _hostsFocusNode,
                              textInputAction: TextInputAction.newline,
                              onSaved: (newValue) {
                                setState(() {
                                  hostNames = newValue!;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text('Charger Type',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            _makeChargerOptions(),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text('Price',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextFormField(
                              style: TextStyle(color: ColorManager.darkGrey),
                              decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              )),
                              focusNode: _priceFocusNode,
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_amenitiesFocusNode),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please provide a price greater than zero.';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                setState(() {
                                  amount = double.parse(newValue!);
                                });
                              },
                            ),
                            const SizedBox(height: 15),
                            const Text('Amenities Available',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextFormField(
                              style: TextStyle(color: ColorManager.darkGrey),
                              decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              )),
                              focusNode: _amenitiesFocusNode,
                              maxLines: 3,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please provide a list of available services';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                setState(() {
                                  amenities = newValue!;
                                });
                              },
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        ColorManager.primary.withOpacity(0.7),
                                    shadowColor: ColorManager.appBlack,
                                    elevation: 6,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25))),
                                child: const Text(
                                  'Add',
                                  style: TextStyle(fontSize: 15),
                                )),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        ColorManager.primary.withOpacity(0.7),
                                    shadowColor: ColorManager.appBlack,
                                    elevation: 6,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25))),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(fontSize: 15),
                                )),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                )));
  }
}
