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
    uid: "",
    firstName: '',
    lastName: '',
    phoneNumber: '',
    level1: true,
    vehicleManufacturer: '',
    vehicleRegistrationNumber: '',
    batteryCapacity: '',
    chargingRequirements: '',
    mileage: '',
    imageUrl: '',
    chargers: [],
    level2: false,
    bookings: [],
    level3: false,
  );
  // ignore: prefer_final_fields
  CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('user');

  UserData get userData => _userData;
  void setUserData(UserData data) async {
    _userData = data;

    notifyListeners();
  }

  Future<void> setLevel2() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      // Store user data in Firestore
      // ignore: unused_local_variable
      if (user != null) {
        DocumentReference documentRef = _usersCollection
            .doc(user.uid); // Replace 'documentId' with the desired document ID

        await documentRef.set({
          'uid': user.uid,
          'firstName': _userData.firstName,
          'phoneNumber': _userData.phoneNumber,
          'lastName': _userData.lastName,
          'level1': _userData.level1,
          'level2': {
            'vehicleManufacturer': _userData.vehicleManufacturer,
            'vehicleRegistrationNumber': _userData.vehicleRegistrationNumber,
            'batteryCapacity': _userData.batteryCapacity,
            'mileage': _userData.mileage,
          },
          'level3': _userData.level3,
          'chargers': _userData.chargers,
          'bookings': _userData.bookings,
          'imageUrl': _userData.imageUrl,
        });

        // Log the ID of the newly created document
        // print('User document ID: ${documentRef.id}');
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving user data: $e');
    }
  }

  Future<void> saveUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      // Store user data in Firestore
      // ignore: unused_local_variable
      if (user != null) {
        DocumentReference documentRef = _usersCollection
            .doc(user.uid); // Replace 'documentId' with the desired document ID

        await documentRef.set({
          'uid': user.uid,
          'firstName': _userData.firstName,
          'phoneNumber': _userData.phoneNumber,
          'lastName': _userData.lastName,
          'level1': _userData.level1,
          'level2': _userData.level2,
          'level3': _userData.level3,
          'chargers': _userData.chargers,
          'bookings': _userData.bookings,
          'imageUrl': _userData.imageUrl,
        });
        notifyListeners();
        // Log the ID of the newly created document
        // print('User document ID: ${documentRef.id}');
      }
    } catch (e) {
      debugPrint('Error saving user data: $e');
    }
  }

  void intialiseUserDataFromFireBase() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot<Object?> snapshot =
          await _usersCollection.doc(user?.uid).get();
      Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
      UserData userD;
      print(data);
      print('9999');
      if (data['level2'] == false) {
        userD = UserData(
            uid: data['uid'],
            bookings: data['bookings'],
            chargers: data['chargers'],
            firstName: data['firstName'],
            lastName: data['lastName'],
            level1: data['level1'],
            level2: data['level2'],
            phoneNumber: data['phoneNumber'],
            chargingRequirements: '',
            vehicleManufacturer: '',
            vehicleRegistrationNumber: '',
            batteryCapacity: '',
            mileage: '',
            level3: data['level3'],
            imageUrl: data['imageUrl']);
      } else {
        userD = UserData(
            uid: data['uid'],
            bookings: data['bookings'],
            chargers: data['chargers'],
            firstName: data['firstName'],
            lastName: data['lastName'],
            level1: data['level1'],
            level2: data['level2'],
            phoneNumber: data['phoneNumber'],
            chargingRequirements: data['level2']['chargingRequirements'],
            vehicleManufacturer: data['level2']['vehicleManufacturer'],
            vehicleRegistrationNumber: data['level2']
                ['vehicleRegistrationNumber'],
            batteryCapacity: data['level2']['batteryCapacity'],
            mileage: data['level2']['mileage'],
            level3: data['level3'],
            imageUrl: data['imageUrl']);
      }
      print(userD);
      setUserData(userD);
    
    } catch (e) {}
  }

  // Future<void> updateUserData() async {
  //   try {
  //     // Reference to the document you want to update
  //     User? user = FirebaseAuth.instance.currentUser;
  //     DocumentReference documentRef = _usersCollection.doc('uid');

  //     // Update the fields you want to change
  //     await documentRef.update({
  //       'name': _userData.name,
  //       'phoneNumber': _userData.phoneNumber,
  //       'level1': _userData.level1,
  //       'level2.vehicleManufacturer': _userData.vehicleManufacturer,
  //       'level2.vehicleRegistrationNumber': _userData.vehicleRegistrationNumber,

  //       // 'vehicleManufacturer': _userData.vehicleManufacturer,
  //       // 'vehicleRegistrationNumber': _userData.vehicleRegistrationNumber,
  //       'level2.batteryCapacity': _userData.batteryCapacity,
  //       'level2.mileage': _userData.range,

  //       'level3': _userData.level3,
  //     });

  //     print('User data updated successfully!');
  //   } catch (e) {
  //     print('Error updating user data: $e');
  //   }
  // }
}
