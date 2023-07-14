import 'package:EVFI/presentation/pages/models/MyCharging.dart';
import 'package:EVFI/presentation/pages/screens/mycharging/header_ui.dart';
import 'package:EVFI/presentation/resources/assets_manager.dart';
import 'package:flutter/material.dart';

import '../../../resources/color_manager.dart';
import 'chargers_data.dart';

class ListCharger extends StatefulWidget {
  const ListCharger({Key? key}) : super(key: key);

  @override
  State<ListCharger> createState() => _ListChargerState();
}

class _ListChargerState extends State<ListCharger> {
  final _priceFocusNode = FocusNode();
  final _aadharFocusNode = FocusNode();
  final _hostsFocusNode = FocusNode();
  final _chargerInfoFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();

  String? StationName, StationAddress;
  double? amount;

  void _submitForm() {
    setState(() {});
    MyChargers.add(MyCharging(
      StationName: StationName!,
      StationAddress: StationAddress!,
      datetime: DateTime.now(),
      amount: amount!,
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.white,),
          title: const Text(
            'Rent your Charger',
            // style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: ColorManager.appBlack,
        ),
        backgroundColor: Colors.grey[200],
        body: Form(
            child: ListView(
          children: <Widget>[
            Container(
              height: 220,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 15),
              child: const HeaderUI(220, true, ImageAssets.blackMarker),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Station Name',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      style: TextStyle(color: ColorManager.appBlack),
                      decoration: const InputDecoration(
                          hintText: 'Amog Public Battery Station',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1.0, color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_addressFocusNode),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a valid station name.';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        StationName = newValue!;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text('Address',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      style: TextStyle(color: ColorManager.appBlack),
                      decoration: const InputDecoration(
                          hintText: 'Thannesar Road, Kurukshetra',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1.0, color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_aadharFocusNode),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a valid address.';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        StationAddress = newValue!;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text('Aadhar No.',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      style: TextStyle(color: ColorManager.appBlack),
                      decoration: const InputDecoration(
                          hintText: 'XXXX-XXXX-XXXX-XXXX',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1.0, color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_hostsFocusNode),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a valid aadhar number.';
                        }
                        return null;
                      },
                      onSaved: (newValue) {},
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text('Host Names',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      style: TextStyle(color: ColorManager.appBlack),
                      decoration: const InputDecoration(
                          hintText: 'Persons available',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1.0, color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                      maxLines: 3,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_chargerInfoFocusNode),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter valid names.';
                        }
                        return null;
                      },
                      onSaved: (newValue) {},
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text('Charger Type',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      style: TextStyle(color: ColorManager.appBlack),
                      decoration: const InputDecoration(
                          hintText: 'A/B/C',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1.0, color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a valid Charger type.';
                        }
                        return null;
                      },
                      onSaved: (newValue) {},
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text('Price',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      style: TextStyle(color: ColorManager.appBlack),
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0, color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      )),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a price greater than zero.';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        amount = double.parse(newValue!);
                      },
                    ),
                  ]),
            ),
            const SizedBox(
              height: 25,
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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25))),
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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25))),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 15),
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        )));
  }
}
