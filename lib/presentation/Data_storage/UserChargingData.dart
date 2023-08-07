// ignore_for_file: file_names, non_constant_identifier_names

class UserChargingData {
  // String vehicleManufacturer;
  // String vehicleNumber;
  // String chargingRequirements;

  String stationName;
  String address;
  //location from marker
  String aadharNumber;
  String hostName;
  String chargerType;
  String availability;
  String price;
  String amenities;
  // image of charger

  UserChargingData({
    // required this.vehicleManufacturer,
    // required this.vehicleNumber,
    // required this.chargingRequirements,

    required this.stationName,
    required this.address,
    //loacation from marker
    required this.aadharNumber,
    required this.hostName,
    required this.chargerType,
    required this.availability,
    required this.price,
    required this.amenities,
    //image of charger
  });

  UserChargingData? get userChargingData => null;
}
