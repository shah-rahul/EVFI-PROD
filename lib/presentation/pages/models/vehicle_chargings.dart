import 'package:evfi/presentation/pages/streams/charging_stream.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Charging {
  String stationName;
  String stationAddress;
  int slotChosen;
  String id;
  String date;
  String amount;
  String phoneNumber;
  LatLng position;

  int status;
  double ratings;
  int type;

  Charging({
    required this.stationName,
    required this.stationAddress,
    required this.slotChosen,
    required this.amount,
    required this.phoneNumber,
    required this.position,
    required this.id,
    required this.date,
    required this.type,
    required this.status,
    this.ratings = 0,
  });
}

class UserChargings extends ChangeNotifier {
  final List<Charging> _vehicleChargings = [
    // Charging(
    //     stationName: "Aomg Charging Station Hub",
    //     stationAddress:
    //         "Sector 39, Karnal, NH-1, GT Karnal Road, Haryana, 132001",
    //     slotChosen: DateTime.now().toString(),
    //     amount: 60,
    //     position: const LatLng(122.9, 27.4),
    //     status: LendingStatus.charging,
    //     type: 1,
    //     ratings: 4.0),
  ];

  List<Charging> get userChargings {
    return [..._vehicleChargings];
  }

  void addCharging(Charging newCharging) {
    // print(userChargings.length);
    _vehicleChargings.add(newCharging);
    notifyListeners();
    ChargingStream.updateChargingStream(_vehicleChargings);
  }
}
