import 'package:google_maps_flutter/google_maps_flutter.dart';

enum Status {
  waiting,
  accepted,
  rejected,
}

enum typeCharger {
  Level1,
  Level2,
  Level3,
}

class MyCharging {
  String StationName;
  String StationAddress;
  DateTime datetime;
  double amount;
  LatLng position;

  int status;
  double ratings;
  int type;

  MyCharging({
    required this.StationName,
    required this.StationAddress,
    required this.datetime,
    required this.amount,
    required this.position,
    required this.type,
    this.status = 0,
    this.ratings = 0,
  });
}
