// ignore_for_file: file_names, non_constant_identifier_names

class UserChargingData {
  String geohash;
  String geopoint;
  

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
  String imageurl;

  UserChargingData({
    required this.geohash,
    required this.geopoint,

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
    required this.imageurl,
  });

  UserChargingData? get userChargingData => null;
}
