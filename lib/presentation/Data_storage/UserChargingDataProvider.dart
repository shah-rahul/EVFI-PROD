// ignore: duplicate_ignore

// ignore: file_names

// ignore_for_file: file_names, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'UserChargingData.dart';

class UserChargingDataProvider extends ChangeNotifier {
  //late UserData _userChargingData;
  UserChargingData _userChargingData = UserChargingData(
    // vehicleManufacturer: '',
    // vehicleNumber: '',
    // chargingRequirements: '',
    geohash: '',
    geopoint: '',
    stationName: '',
    address: '',
    //loaction from marker
    aadharNumber: '',
    hostName: '',
    chargerType: '',
    availability: '',
    price: '',
    amenities: '',
    //image of charger
    imageurl: '',
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
      DocumentReference documentRef = await _usersCollection.add({
        'g':{
         'geohash': _userChargingData.geohash,
         'geopoint':_userChargingData.geopoint,
        },
        'info': {
          'Station Name': _userChargingData.stationName,
          'Address': _userChargingData.address,
          //loaction from marker
          'Aadhar Number': _userChargingData.aadharNumber,
          'Host Name ': _userChargingData.hostName,
          'Charger Type': _userChargingData.chargerType,
          //availability
          'Price': _userChargingData.price,
          'Amenities': _userChargingData.amenities,
          'Imageurl':_userChargingData.imageurl,
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
