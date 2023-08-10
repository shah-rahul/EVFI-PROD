// ignore: duplicate_ignore

// ignore: file_names

// ignore_for_file: file_names, duplicate_ignore

import 'package:evfi/presentation/Data_storage/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserDataProvider extends ChangeNotifier {
  //late UserData _userData;
  UserData _userData = UserData(
    Uid: "Null",

    name: 'Null',
    phoneNumber: 'Null',
    level1: false,
    vehicleManufacturer: 'Null',
    vehicleRegistrationNumber: 'Null',
    chargerInfo: 'Null',
    level2: false,
    // stationName: '',
    // address: '',
    // aadharNumber: '',
    // hostName: '',
    // chargerType: '',
    // price: '',
    // amenities: '',
    isProvider: false,
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
      User? user = FirebaseAuth.instance.currentUser;
      // Store user data in Firestore
      // ignore: unused_local_variable
      if (user != null) {
        DocumentReference documentRef = await _usersCollection.add({
          'Uid': user.uid,
          'Name': _userData.name,
          'PhoneNumber': _userData.phoneNumber,
          'level 1': _userData.level1,

          // 'level 2': _userData.level2,
          'level 2': {
            'Vehicle Manufacturer': _userData.vehicleManufacturer,
            'Vehicle Registration Number': _userData.vehicleRegistrationNumber,
            'Charger Info': _userData.chargerInfo,
          },
          // 'Station Name':_userData.stationName,
          // 'Address':_userData.address,
          // 'Aadhar Number':_userData.aadharNumber,
          // 'Host Name ':_userData.hostName,
          // 'Charger Type':_userData.chargerType,
          // 'Price':_userData.price,
          // 'Amenities':_userData.amenities,
          'isProvider': _userData.isProvider,
        });

        // Log the ID of the newly created document
        // print('User document ID: ${documentRef.id}');
      }
    } catch (e) {
      // print('Error saving user data: $e');
    }
  }

  Future<void> updateUserData() async {
    try {
      // Reference to the document you want to update
      User? user = FirebaseAuth.instance.currentUser;
      DocumentReference documentRef = _usersCollection.doc('Uid');

      // Update the fields you want to change
      await documentRef.update({
        'Name': _userData.name,
        'PhoneNumber': _userData.phoneNumber,
        'level 1': _userData.level1,
        'level 2.Vehicle Manufacturer': _userData.vehicleManufacturer,
        'level 2.Vehicle Registration Number':
            _userData.vehicleRegistrationNumber,
        'level 2.Charger Info': _userData.chargerInfo,
        'isProvider': _userData.isProvider,
      });

      // print('User data updated successfully!');
    } catch (e) {
      //print('Error updating user data: $e');
    }
  }
}
