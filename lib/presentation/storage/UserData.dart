// ignore_for_file: file_names, non_constant_identifier_names

class UserData {
  String uid;

  String phoneNumber;

  bool level1;
  String vehicleManufacturer;
  String vehicleRegistrationNumber;
  String batteryCapacity;
  String mileage;
  String chargingRequirements;

  dynamic level2;
  List chargers;
  List bookings;
  String imageUrl;
  String firstName;
  String lastName;
  bool level3;

  UserData({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.level1,
    required this.imageUrl,
    required this.vehicleManufacturer,
    required this.vehicleRegistrationNumber,
    required this.batteryCapacity,
    required this.chargingRequirements,
    required this.mileage,
    required this.bookings,
    required this.chargers,
    required this.level2,
    // required this.stationName,
    // required this.address,
    // required this.aadharNumber,
    // required this.hostName,
    // required this.chargerType,
    // required this.price,
    // required this.amenities,
    required this.level3,
  });
}
