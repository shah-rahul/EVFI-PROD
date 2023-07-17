import 'package:EVFI/presentation/Data_storage/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserDataProvider extends ChangeNotifier {
  late UserData _userData;
  CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('Users');

  UserData get userData => _userData;
  void setUserData(UserData data) {
    _userData = data;
    notifyListeners();
  }

  Future<void> saveUserData() async {
    try {
      // Store user data in Firestore
      DocumentReference documentRef = await _usersCollection.add({
        'name': _userData.name,
        'phoneNumber': _userData.phoneNumber,
        'vehicleManufacturer': _userData.vehicleManufacturer,
        'vehicleNumber': _userData.vehicleNumber,
        'chargingType': _userData.chargingType,
      });

      // Log the ID of the newly created document
      print('User document ID: ${documentRef.id}');
    } catch (e) {
      print('Error saving user data: $e');
    }
  }
}
