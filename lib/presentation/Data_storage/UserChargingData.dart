// ignore_for_file: file_names, non_constant_identifier_names

class UserChargingData {
  String Uid;
  String geohash;
  String geopoint;

  String stationName;
  String address;
  //location from marker

  String city;
  String pin;
  String state;

  String aadharNumber;
  String hostName;
  String chargerType;
  String availability;
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
    required this.availability,
    required this.price,
    required this.amenities,
    //image of charger
    required this.imageurl,
  });

  UserChargingData? get userChargingData => null;
}
