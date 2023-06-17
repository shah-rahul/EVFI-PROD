import 'package:intl/intl.dart';

enum Status {
  waiting,
  accepted,
  rejected,
}

class Booking {
  String StationName;
  String StationAddress;
  DateTime datetime;
  double amount;
  int status;
  double ratings;

  Booking(
      {required this.StationName,
      required this.StationAddress,
      required this.datetime,
      required this.amount,
      required this.status,
      required this.ratings});
}
