// ignore_for_file: file_names, non_constant_identifier_names

class UserData {
  String Uid;
  String name;
  String phoneNumber;

  bool level1;
  // String vehicleManufacturer;
  // String vehicleNumber;
  // String chargingRequirements;
  bool level2;
  // String stationName;
  // String address;
  // String aadharNumber;
  // String hostName;
  // String chargerType;
  // String price;
  // String amenities;
  bool isProvider;
  
  UserData({
    required this.Uid,
    required this.name,
    required this.phoneNumber,
    required this.level1,
    // required this.vehicleManufacturer,
    // required this.vehicleNumber,
    // required this.chargingRequirements,
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
