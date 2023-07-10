import 'package:intl/intl.dart';

enum Status {
  accepted,
  declined,
}

class Booking {
  String CustomerName;
  String StationName;
  String mobileNumber;
  DateTime datetime;
  int amount;
  int status;
  double ratings;

  Booking(
      {required this.CustomerName,
      required this.StationName,
      required this.mobileNumber,
      required this.datetime,
      required this.amount,
      required this.status,
      required this.ratings});
}
