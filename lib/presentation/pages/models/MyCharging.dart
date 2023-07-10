enum Status {
  waiting,
  accepted,
  rejected,
}

class MyCharging {
  String StationName;
  String StationAddress;
  DateTime datetime;
  double amount;
  int status;
  double ratings;

  MyCharging(
      {required this.StationName,
      required this.StationAddress,
      required this.datetime,
      required this.amount,
      required this.status,
      required this.ratings});
}
