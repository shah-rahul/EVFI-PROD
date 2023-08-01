


// ignore_for_file: file_names

enum Status {
  accepted,
  declined,
}

class Booking {
  // ignore: non_constant_identifier_names
  String CustomerName;
  // ignore: non_constant_identifier_names
  String StationName;
  String mobileNumber;
  DateTime datetime;
  int amount;
  int status;
  double ratings;

  Booking(
      // ignore: non_constant_identifier_names
      {required this.CustomerName,
      // ignore: non_constant_identifier_names
      required this.StationName,
      required this.mobileNumber,
      required this.datetime,
      required this.amount,
      required this.status,
      required this.ratings});
}
