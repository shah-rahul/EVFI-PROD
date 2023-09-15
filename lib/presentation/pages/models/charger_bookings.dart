// ignore_for_file: file_names
import 'package:evfi/presentation/resources/values_manager.dart';

class Booking {
  double amount;
  String timeStamp;
  String stationName;
  String customerName;
  String customerMobileNumber;
  int status;
  double ratings;

  Booking(
      {required this.amount,
      required this.timeStamp,
      required this.stationName,
      required this.customerName,
      required this.customerMobileNumber,
      required this.status,
      required this.ratings});
}

class ProviderBookings {
  List<Booking> _chargerBookings = [];

  List<Booking> get providerBookings {
    return [..._chargerBookings];
  }
}
