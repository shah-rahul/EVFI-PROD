// ignore_for_file: file_names, non_constant_identifier_names

class UserData {
  String uid;
  String name;
  String phoneNumber;

  bool level1;
  String vehicleManufacturer;
  String vehicleRegistrationNumber;
  String batteryCapacity;
  String range;
  String chargerInfo;
  bool level2;

  bool isProvider;

  UserData({
    required this.uid,
    required this.name,
    required this.phoneNumber,
    required this.level1,
    required this.vehicleManufacturer,
    required this.vehicleRegistrationNumber,
    required this.batteryCapacity,
    required this.range,
    required this.chargerInfo,
    required this.level2,
    // required this.stationName,
    // required this.address,
    // required this.aadharNumber,
    // required this.hostName,
    // required this.chargerType,
    // required this.price,
    // required this.amenities,
    required this.isProvider,
  });
}