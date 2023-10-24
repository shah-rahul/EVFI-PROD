//function to convert lat. & long. ==>> geohash string

// ignore_for_file: prefer_const_declarations, non_constant_identifier_names

/*
this function takes input parameters:-
(1)Latitude
(2)Longitude
(3)(if wanted)length of string required after geohash

//how to use:-

-> India Gate, New Delhi
double latitude = 28.6132;
double longitude = 77.2291; 
String geohash = encodeGeohash(latitude, longitude, precision: 12);
//this will return string geohash = 'ttnfv2uebrnf'
print(geohash);
*/



import 'package:get/get.dart';

String encodeGeohash(double latitude, double longitude, {int precision = 12}) {
  final int bitsPerChar = 5;
  final String BASE32 = '0123456789bcdefghjkmnpqrstuvwxyz';
  final int maxPrecision = 22;

  if (precision < 1 || precision > maxPrecision) {
    throw ArgumentError('Precision must be between 1 and $maxPrecision');
  }

  double minLatitude = -90.0;
  double maxLatitude = 90.0;
  double minLongitude = -180.0;
  double maxLongitude = 180.0;

  StringBuffer geohash = StringBuffer();
  bool isEven = true;
  int bit = 0;
  int ch = 0;

  while (geohash.length < precision) {
    double mid;
    if (isEven) {
      mid = (minLongitude + maxLongitude) / 2;
      if (longitude > mid) {
        ch |= (1 << (bitsPerChar - bit - 1));
        minLongitude = mid;
      } else {
        maxLongitude = mid;
      }
    } else {
      mid = (minLatitude + maxLatitude) / 2;
      if (latitude > mid) {
        ch |= (1 << (bitsPerChar - bit - 1));
        minLatitude = mid;
      } else {
        maxLatitude = mid;
      }
    }

    isEven = !isEven;
    if (bit < (bitsPerChar - 1)) {
      bit++;
    } else {
      geohash.write(BASE32[ch]);
      bit = 0;
      ch = 0;
    }
  }

  return geohash.toString();
}


String convertToDegrees(double value, String positiveDirection, String negativeDirection) {
  String direction = value >= 0 ? positiveDirection : negativeDirection;
  double degrees = value.abs().toPrecision(7);
  // int degreesInt = degrees.toInt();
  // double minutes = (degrees - degreesInt) * 60;
  // int minutesInt = minutes.toInt();
  // double seconds = (minutes - minutesInt) * 60;

  return '$degrees° $direction';
}

// String convertToDegrees(double value, String positiveDirection, String negativeDirection) {
//   String direction = value >= 0 ? positiveDirection : negativeDirection;
//   double degrees = value.abs();
//   int degreesInt = degrees.toInt();
//   double minutes = (degrees - degreesInt) * 60;
//   int minutesInt = minutes.toInt();
//   double seconds = (minutes - minutesInt) * 60;

//   return '$degreesInt° $minutesInt\' ${seconds.toStringAsFixed(2)}" $direction';
// }

//   how to use:-

//   double latitude = 37.7749;
//   double longitude = -122.4194;
  
//   String convertedLatitude = convertToDegrees(latitude, 'N', 'S');
//   String convertedLongitude = convertToDegrees(longitude, 'E', 'W');

//   print(convertedLatitude); // Output: 37° 46' 29.64" N
//   print(convertedLongitude); // Output: 122° 25' 9.84" W
// }
