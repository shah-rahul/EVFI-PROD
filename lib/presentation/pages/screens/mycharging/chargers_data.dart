import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/my_charging.dart';

class Chargers with ChangeNotifier {
  final List<MyCharging> MyChargers = [
    MyCharging(
        StationName: "Aomg Charging Station Hub",
        StationAddress:
            "Sector 39, Karnal, NH-1, GT Karnal Road, Haryana, 132001",
        datetime: DateTime.now(),
        amount: 120,
        position: LatLng(1.8, 2.4),
        status: 0,
        type: 0,
        ratings: 2.0),
    MyCharging(
        StationName: "Aomg Charging Station Hub",
        StationAddress:
            "Sector 39, Karnal, NH-1, GT Karnal Road, Haryana, 132001",
        datetime: DateTime.now(),
        amount: 120,
        position: LatLng(1.8, 2.4),
        status: 0,
        type: 1,
        ratings: 4.0),
    // MyCharging(
    //     StationName: "Aomg Charging Station Hub",
    //     StationAddress:
    //         "Sector 39, Karnal, NH-1, GT Karnal Road, Haryana, 132001",
    //     datetime: DateTime.now(),
    //     amount: 120,
    //     status: 0,
    //     ratings: 4.0),
    // MyCharging(
    //     StationName: "Aomg Charging Station Hub",
    //     StationAddress:
    //         "Sector 39, Karnal, NH-1, GT Karnal Road, Haryana, 132001",
    //     datetime: DateTime.now(),
    //     amount: 120,
    //     status: 0,
    //     ratings: 4.0),
    // MyCharging(
    //     StationName: "Aomg Charging Station Hub",
    //     StationAddress:
    //         "Sector 39, Karnal, NH-1, GT Karnal Road, Haryana, 132001",
    //     datetime: DateTime.now(),
    //     amount: 120,
    //     status: 1,
    //     ratings: 4.0),
    // MyCharging(
    //     StationName: "Aomg Charging Station Hub",
    //     StationAddress:
    //         "Sector 39, Karnal, NH-1, GT Karnal Road, Haryana, 132001",
    //     datetime: DateTime.now(),
    //     amount: 120,
    //     status: 1,
    //     ratings: 4.0)
  ];

  Future<void> addCharger(
      {required String StationName,
      required String StationAddress,
      required double amount,
      required LatLng position}) async {
    typeCharger type = typeCharger.Level1;
    MyChargers.add(MyCharging(
        StationName: StationName,
        StationAddress: StationAddress,
        datetime: DateTime.now(),
        amount: amount,
        position: position,
        type: type.index));
    notifyListeners();
  }
}
