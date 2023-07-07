//To add a new station in firestore

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final _longitudeFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  void _addInFirestore() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    String geohash = encodeGeohash(latitude!, longitude!, precision: 9);
    GeoPoint coordinate = GeoPoint(latitude!, longitude!);
    var marker = <String, dynamic>{
      'geo': <String, dynamic>{
        'geohash': geohash, 'geopoint': coordinate
      }
    };
    await FirebaseFirestore.instance
        .collection('Markers')
        .add(marker).then((_) => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 25.0,
          right: 25.0,
          left: 25.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10),
      child: Form(
        key: _form,
        child: Container(
          height: MediaQuery.sizeOf(context).height * 0.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
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
                height: 13,
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
    );
  }
}
