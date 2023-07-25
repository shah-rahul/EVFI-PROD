//create a User Model
// ignore_for_file: non_constant_identifier_names

class UserModel {
  final String? id;
  final String fullName;
  final String phoneNo;
  
  final String vehicle_manufacturer;
  
  final String vehicle_registration_number;
  
  final String charger_type;
  
  final String charger_speed;
  
  const UserModel({
    this.id,
    required this.fullName,
    required this.phoneNo,
    required this.vehicle_manufacturer,
    required this.vehicle_registration_number,
    required this.charger_type, //charger type A,B,C
    required this.charger_speed,
   
  });

  toJson() {
    return {
      "FullName": fullName,
      "Phone": phoneNo,
      "vehicle_manufacturer":vehicle_manufacturer,
      "vehivle_registration_number":vehicle_registration_number,
      "charger_type":charger_type,
      "charger_speed":charger_speed,
    };
  }
}
