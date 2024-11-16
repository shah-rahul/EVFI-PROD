import 'dart:async';
import '../widgets/BookingDataWidget.dart';

class BookingProviderState {
  final StreamController<BookingDataWidget> _bookingStreamController =
      StreamController<BookingDataWidget>();

  Stream<BookingDataWidget> get stream {
    return _bookingStreamController.stream;
  }

  void dispose() {
    _bookingStreamController.close();
  }

  Sink get inputSink => _bookingStreamController.sink;

  void addBooking(BookingDataWidget booking) {
    inputSink.add(booking);
    print("--------------");
  }
}
