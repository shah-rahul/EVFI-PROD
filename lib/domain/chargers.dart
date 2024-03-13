import 'package:hive/hive.dart';

part 'chargers.g.dart';

@HiveType(typeId: 1)
class ChargerModel extends HiveObject {
  ChargerModel({required this.data});
  
  @HiveField(0)
  Map<String, dynamic> data; // Assuming 'g' contains geohash and geopoint

  // Other fields as needed
}
