//function to convert lat. & long. ==>> geohash string

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



String encodeGeohash(double latitude, double longitude, {int precision = 12}) {
  final int BITS_PER_CHAR = 5;
  final String BASE32 = '0123456789bcdefghjkmnpqrstuvwxyz';
  final int MAX_PRECISION = 22;

  if (precision < 1 || precision > MAX_PRECISION) {
    throw ArgumentError('Precision must be between 1 and $MAX_PRECISION');
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
        ch |= (1 << (BITS_PER_CHAR - bit - 1));
        minLongitude = mid;
      } else {
        maxLongitude = mid;
      }
    } else {
      mid = (minLatitude + maxLatitude) / 2;
      if (latitude > mid) {
        ch |= (1 << (BITS_PER_CHAR - bit - 1));
        minLatitude = mid;
      } else {
        maxLatitude = mid;
      }
    }

    isEven = !isEven;
    if (bit < (BITS_PER_CHAR - 1)) {
      bit++;
    } else {
      geohash.write(BASE32[ch]);
      bit = 0;
      ch = 0;
    }
  }

  return geohash.toString();
}
