// ignore: duplicate_ignore

// ignore: file_names

// ignore_for_file: file_names, duplicate_ignore

import 'package:evfi/presentation/storage/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserDataProvider extends ChangeNotifier {
  //late UserData _userData;
  UserData _userData = UserData(
    uid: "Null",
    name: 'Null',
    phoneNumber: 'Null',
    level1: false,
    vehicleManufacturer: 'Null',
    vehicleRegistrationNumber: 'Null',
    batteryCapacity: 'Null',
    range: 'null',
    chargerInfo: 'Null',
    level2: false,
    isProvider: false,
  );
  // ignore: prefer_final_fields
  CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('user');

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
        DocumentReference documentRef = _usersCollection.doc(user.uid); // Replace 'documentId' with the desired document ID

await documentRef.set({
  'uid': user.uid,
  'name': _userData.name,
  'phoneNumber': _userData.phoneNumber,
  'level1': _userData.level1,
  'level2': {
    'vehicleManufacturer': _userData.vehicleManufacturer,
    'vehicleRegistrationNumber': _userData.vehicleRegistrationNumber,
    'batteryCapacity': _userData.batteryCapacity,
    'mileage': _userData.range,
    'chargerInfo': _userData.chargerInfo,
  },
  'isProvider': _userData.isProvider,
});
        
        // Log the ID of the newly created document
        // print('User document ID: ${documentRef.id}');
      }
    } catch (e) {
      debugPrint('Error saving user data: $e');
    }
  }

  Future<void> updateUserData() async {
    try {
      // Reference to the document you want to update
      User? user = FirebaseAuth.instance.currentUser;
      DocumentReference documentRef = _usersCollection.doc('uid');

      // Update the fields you want to change
      await documentRef.update({
        'name': _userData.name,
        'phoneNumber': _userData.phoneNumber,
        'level1': _userData.level1,
        // 'level 2.Vehicle Manufacturer': _userData.vehicleManufacturer,
        // 'level 2.Vehicle Registration Number':
        //     _userData.vehicleRegistrationNumber,

        // 'level 2.Charger Info': _userData.chargerInfo,
        'vehicleManufacturer': _userData.vehicleManufacturer,
        'vehicleRegistrationNumber': _userData.vehicleRegistrationNumber,
        'batteryCapacity': _userData.batteryCapacity,
        'mileage': _userData.range,
        'chargerInfo': _userData.chargerInfo,
        'isProvider': _userData.isProvider,
      });

      print('User data updated successfully!');
    } catch (e) {
      print('Error updating user data: $e');
    }
  }
}
