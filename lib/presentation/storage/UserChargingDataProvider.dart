// ignore: duplicate_ignore

// ignore: file_names

// ignore_for_file: file_names, duplicate_ignore

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'UserChargingData.dart';

class UserChargingDataProvider extends ChangeNotifier {
  //late UserData _userChargingData;
  UserChargingData _userChargingData = UserChargingData(
    // vehicleManufacturer: '',
    // vehicleNumber: '',
    // chargingRequirements: '',
    uid: "Null",
    geohash: 'Null',
    // geopoint: const GeoPoint(0.0, 0.0),

    geopoint: new GeoPoint(0.0, 0.0),
    stationName: 'Null',
    address: 'Null',
    //loaction from marker
    city: 'Null',
    pin: 'Null',
    state: 'Null',
    aadharNumber: 'Null',
    hostName: 'Null',
    chargerType: 'Null',
    startAvailability: 'Null',// DateTime.now(),
    endAvailability: 'Null',//DateTime.now(),
    price: 'Null',
    amenities: 'Null',
    //image of charger
    imageUrl: [],
  );
  // ignore: prefer_final_fields
  CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('chargers');

  UserChargingData get userChargingData => _userChargingData;
  void setUserChargingData(UserChargingData data) {
    _userChargingData = data;
    notifyListeners();
  }

  Future<void> saveUserChargingData() async {
    try {
      // Store user data in Firestore
      // ignore: unused_local_variable
      User? user = FirebaseAuth.instance.currentUser;
      DocumentReference documentRef = await _usersCollection.add({
        'uid': user!.uid,
        'g': {
          'geohash': _userChargingData.geohash,
          'geopoint': _userChargingData.geopoint,
        },
        'info': {
          'stationName': _userChargingData.stationName,
          'address': _userChargingData.address,
          'city': _userChargingData.city,
          'pin': _userChargingData.pin,
          'state': _userChargingData.state,
          'aadharNumber': _userChargingData.aadharNumber,
          'hostName': _userChargingData.hostName,
          'chargerType': _userChargingData.chargerType,
          'price': _userChargingData.price,
          'amenities': _userChargingData.amenities,
          'imageUrl': _userChargingData.imageUrl,
          'start': _userChargingData.startAvailability,
          'end': _userChargingData.endAvailability,
          //charger image
          // 'isProvider':_userChargingData.isProvider,
        }
      });

      // Log the ID of the newly created document
      //  print('User document ID: ${documentRef.id}');
    } catch (e) {
      // print('Error saving user data: $e');
    }
  }
}