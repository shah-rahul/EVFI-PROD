// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evfi/presentation/resources/values_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'UserChargingData.dart';

class UserChargingDataProvider extends ChangeNotifier {
  //late UserData _userChargingData;
  UserChargingData _userChargingData = UserChargingData(
    // vehicleManufacturer: '',
    // vehicleNumber: '',
    // chargingRequirements: '',
    chargerId: "Null",
    uid: "Null",
    geohash: 'Null',
    // geopoint: const GeoPoint(0.0, 0.0),

    geopoint: const GeoPoint(0.0, 0.0),
    stationName: 'Null',
    address: 'Null',
    //loaction from marker
    city: 'Null',
    pin: 'Null',
    state: 'Null',
    aadharNumber: 'Null',
    hostName: 'Null',
    chargerType: 'Null',
    start: 0, // DateTime.now(),
    end: 0, //DateTime.now(),
    timeslot: 0,
    price: 'Null',
    amenities: 'Null',
    aadharImages: [],
    status: ChargerStatus.available.index,
    //image of charger
    imageUrl: [],
  );
  // ignore: prefer_final_fields
  CollectionReference _chargersCollection = FirebaseFirestore.instance.collection('chargers');

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
      DocumentReference documentRef = await _chargersCollection.add({
        'chargerId': _userChargingData.chargerId,
        'uid': user!.uid,
        'g': {
          'geohash': _userChargingData.geohash,
          'geopoint': _userChargingData.geopoint,
        },
        'timeSlot': 0,
        'info': {
          'stationName': _userChargingData.stationName,
          'address': _userChargingData.address,
          'city': _userChargingData.city,
          'pinCode': _userChargingData.pin,
          'state': _userChargingData.state,
          'aadharNumber': _userChargingData.aadharNumber,
          'hostName': _userChargingData.hostName,
          'chargerType': _userChargingData.chargerType,
          'price': _userChargingData.price,
          'amenities': _userChargingData.amenities,
          'imageUrl': _userChargingData.imageUrl,
          'start': _userChargingData.start,
          'end': _userChargingData.end,
          'aadharImages': _userChargingData.aadharImages,
          'status': ChargerStatus.available.index,
          //'timeSlot': 0,
          //charger image
          // 'isProvider':_userChargingData.isProvider,
        }
      }).then((docRef) async {
        // print(docRef.id);
        await _chargersCollection
            .doc(docRef.id)
            .update({'chargerId': docRef.id});
        return docRef;
      });
      // Log the ID of the newly created document
      //  print('User document ID: ${documentRef.id}');
    } catch (e) {
      print('Error saving user data: $e');
    }
  }
}
