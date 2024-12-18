// ignore_for_file: file_names, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class UserChargingData {
  String chargerId;
  String uid;
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

  int start;
  int end;
  int timeslot;
  num status;
  String price;
  String amenities;
  // image of charger
  List<String> imageUrl, aadharImages;

  UserChargingData(
      {required this.chargerId,
      required this.uid,
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
      required this.start,
      required this.end,
      required this.timeslot,
      required this.price,
      required this.amenities,
      required this.status,
      //image of charger
      required this.imageUrl,
      required this.aadharImages});

  UserChargingData? get userChargingData => null;
}
