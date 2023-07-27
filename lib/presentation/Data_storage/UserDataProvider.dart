// ignore: duplicate_ignore

// ignore: file_names

// ignore_for_file: file_names, duplicate_ignore

import 'package:EVFI/presentation/Data_storage/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserDataProvider extends ChangeNotifier {
  //late UserData _userData;
  UserData _userData = UserData(
    Uid: "",
    name: '',
    phoneNumber: '',
    level1: false,
    vehicleManufacturer: '',
    vehicleNumber: '',
    chargingRequirements: '',
    level2: false,
    stationName: '',
    address: '',
    aadharNumber: '',
    hostName: '',
    chargerType: '',
    price: '',
    amenities: '',
    level3: false,
  );
  // ignore: prefer_final_fields
  CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('UserChargingRegister');

  UserData get userData => _userData;
  void setUserData(UserData data) {
    _userData = data;
    notifyListeners();
  }

  Future<void> saveUserData() async {
    try {
      // Store user data in Firestore
      // ignore: unused_local_variable
      DocumentReference documentRef = await _usersCollection.add({
        'Name': _userData.name,
        'Phone Number': _userData.phoneNumber,
        'level 1': _userData.level1,
        'Vehicle Manufacturer': _userData.vehicleManufacturer,
        'Vehicle Number': _userData.vehicleNumber,
        'Charging Requirements': _userData.chargingRequirements,
        'level 2': _userData.level2,
        'Station Name':_userData.stationName,
        'Address':_userData.address,
        'Aadhar Number':_userData.aadharNumber,
        'Host Name ':_userData.hostName,
        'Charger Type':_userData.chargerType,
        'Price':_userData.price,
        'Amenities':_userData.amenities,
        'Level 3':_userData.level3,
       
      });
      
      // Log the ID of the newly created document
    //  print('User document ID: ${documentRef.id}');
    } catch (e) {
     // print('Error saving user data: $e');
    }
  }
}
