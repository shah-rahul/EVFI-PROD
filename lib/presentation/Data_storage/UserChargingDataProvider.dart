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
    Uid: "Null",
    geohash: 'Null',
    // geopoint: const GeoPoint(0.0, 0.0),
    
    geopoint: new GeoPoint(0.0,0.0),
    stationName: 'Null',
    address: 'Null',
    //loaction from marker
    city: 'Null',
    pin:'Null',
    state:'Null',
    aadharNumber: 'Null',
    hostName: 'Null',
    chargerType: 'Null',
    startavailability: DateTime.now(),
    endavailability: DateTime.now(),
    price: 'Null',
    amenities: 'Null',
    //image of charger
    imageurl: 'Null',
  );
  // ignore: prefer_final_fields
  CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('Chargers');

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
        'Uid':user!.uid,
        'g':{
         'geohash': _userChargingData.geohash,
         'geopoint':_userChargingData.geopoint,
        },
        'info': {
          'Station Name': _userChargingData.stationName,
          'Address': _userChargingData.address,
          'City':_userChargingData.city,
          'Pin':_userChargingData.pin,
          'State':_userChargingData.state,
          //loaction from marker
          'Aadhar Number': _userChargingData.aadharNumber,
          'Host Name ': _userChargingData.hostName,
          'Charger Type': _userChargingData.chargerType,
          //availability
          'Price': _userChargingData.price,
          'Amenities': _userChargingData.amenities,
          'Imageurl':_userChargingData.imageurl,
          'Availability':{
            'Start ':_userChargingData.startavailability,
            'End':_userChargingData.endavailability,
          },
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
