import 'dart:async';

import 'package:evfi/presentation/pages/models/vehicle_chargings.dart';

class ChargingStream {
  // final List<Charging> userChargings = UserChargings().userChargings;
  static final StreamController<List<Charging>> _chargingStreamController =
      StreamController<List<Charging>>.broadcast();

  static Stream<List<Charging>> get stream {
    return _chargingStreamController.stream;
  }

  static void updateChargingStream(List<Charging> booking) {
    print(booking.first.stationName);
    print(booking.length);
    _chargingStreamController.add(booking);
    print('******************');
  }

  static void dispose() {
    _chargingStreamController.close();
  }
}