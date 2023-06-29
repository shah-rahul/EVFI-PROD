//function to convert string geohash ==>> lat. and long.

/*
this function takes input parameters:-
(1)geohashed String to be decoded

//how to use:-

-> India Gate, New Delhi
String xyz = 'ttnfv2u';
GeoPoint point = decodeGeohash(xxx);   //this will return an object of class point that has lat. & long.
where,, -> LATITUDE = point.latitude (28.613204956054688)
        -> LONGITUDE = point.longitude (77.22908020019531)

print('latitude = ${point.latitude}');
print('longitude = ${point.longitude}');
*/


class GeoPoint {
  double latitude;
  double longitude;

  GeoPoint(this.latitude, this.longitude);
}

GeoPoint decodeGeohash(String geohash) {
  final int BITS_PER_CHAR = 5;
  final String BASE32 = '0123456789bcdefghjkmnpqrstuvwxyz';

  double minLatitude = -90.0;
  double maxLatitude = 90.0;
  double minLongitude = -180.0;
  double maxLongitude = 180.0;

  bool isEven = true;
  double latitudeError = 90.0;
  double longitudeError = 180.0;

  for (int i = 0; i < geohash.length; i++) {
    int charIndex = BASE32.indexOf(geohash[i]);
    for (int bit = BITS_PER_CHAR - 1; bit >= 0; bit--) {
      int mask = 1 << bit;
      if (isEven) {
        longitudeError /= 2;
        if ((charIndex & mask) != 0) {
          minLongitude = (minLongitude + maxLongitude) / 2;
        } else {
          maxLongitude = (minLongitude + maxLongitude) / 2;
        }
      } else {
        latitudeError /= 2;
        if ((charIndex & mask) != 0) {
          minLatitude = (minLatitude + maxLatitude) / 2;
        } else {
          maxLatitude = (minLatitude + maxLatitude) / 2;
        }
      }
      isEven = !isEven;
    }
  }

  double latitude = (minLatitude + maxLatitude) / 2;
  double longitude = (minLongitude + maxLongitude) / 2;

  return GeoPoint(latitude, longitude);
}
