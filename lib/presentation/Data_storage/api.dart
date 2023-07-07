import 'package:cloud_firestore/cloud_firestore.dart';

class Api {
  // Firestore collection name
  static const String userCollection = 'Users';

  // Store user name in Firestore
  static Future<void> storeUserName({
     required String name,
    
  }) async {
    await FirebaseFirestore.instance.collection(userCollection).add({
      'name': name,
   
    });
  }

  // Store user phone number in Firestore
  static Future<void> storeUserPhone({
    required String phoneNumber,
  }) async {
    await FirebaseFirestore.instance.collection(userCollection).add({
      'phoneNumber': phoneNumber,
    });
  }
  // Store user vehicle number in Firestore
  static Future<void> storeVehicleNumber({
    required String vehicleNumber, 
  }) async {
    await FirebaseFirestore.instance.collection(userCollection).add({
      'vehicleNumber': vehicleNumber,
    });
  }
  // Store user vehicle manufacturer in Firestore
  static Future<void> storeVehicleManufacturer({
    required String vehicleManufacturer,
  }) async {
    await FirebaseFirestore.instance.collection(userCollection).add({
      'vehicleManufacturer': vehicleManufacturer,
    });
  }
  // Store user charger type in Firestore
  static Future<void> storeChargerType({
    required String chargingType,
  }) async {
    await FirebaseFirestore.instance.collection(userCollection).add({
      'chargingType': chargingType,
    });
  }
  // Store user charger speed in Firestore
  static Future<void> storeChargerSpeed({
    required String chargingSpeed,
  }) async {
    await FirebaseFirestore.instance.collection(userCollection).add({
     'chargingSpeed': chargingSpeed,
    });
  }
}
