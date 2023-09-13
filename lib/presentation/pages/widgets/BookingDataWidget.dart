enum BookingStatus {
  Requested,
  Accepted,
  Charging,
  Completed,
  Declined,
  Canceled,
}

class BookingDataWidget {
  String stationName;
  String userName;
  double price;
  String startTime;
  String endTime;
  BookingStatus status;

  BookingDataWidget(
      {required this.stationName,
      required this.userName,
      required this.price,
      required this.startTime,
      required this.endTime,
      required this.status});
}
