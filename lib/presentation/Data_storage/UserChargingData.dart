// ignore_for_file: file_names, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class UserChargingData {
  String Uid;
  String geohash;
  GeoPoint geopoint;

  String stationName;
  String address;
  //location from marker

  String city;
  String pin;
  String state;

  String aadharNumber;
  String hostName;
  String chargerType;

  DateTime startavailability;
  DateTime endavailability;

  String price;
  String amenities;
  // image of charger
  String imageurl;

  UserChargingData({
    required this.Uid,
    required this.geohash,
    required this.geopoint,
    required this.stationName,
    required this.address,
    //loacation from marker
    required this.city,
    required this.pin,
    required this.state,
    required this.aadharNumber,
    required this.hostName,
    required this.chargerType,
    required this.startavailability,
    required this.endavailability,
    required this.price,
    required this.amenities,
    //image of charger
    required this.imageurl,
  });

  UserChargingData? get userChargingData => null;
}
