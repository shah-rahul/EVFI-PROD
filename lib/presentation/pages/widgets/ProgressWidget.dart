import 'package:flutter/material.dart';
import 'dart:async';

class ProgressWidget extends StatefulWidget {
  DateTime startTime;
  DateTime endTime;
   ProgressWidget({required this.startTime,required this.endTime});
  @override
  State<ProgressWidget> createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // Start a timer to update UI every second
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {}); // Trigger UI update
    });
  }

  @override
  void dispose() {
    // Dispose the timer when the widget is disposed
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    bool isBookingInProgress = now.isAfter(widget.startTime) && now.isBefore(widget.endTime);

    Duration remainingTime =
        isBookingInProgress ? widget.endTime.difference(now) : Duration.zero;
      return Container(
        child: isBookingInProgress
            ? CircularTimer(
                duration: remainingTime,
              )
            : Text('Booking not in progress'),
      
    );
  }
}

class CircularTimer extends StatelessWidget {
  final Duration duration;

  const CircularTimer({Key? key, required this.duration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress =
        1 - (duration.inSeconds / (60 * 60)); // Calculate progress (in hours)

    return SizedBox(
      width: 200,
      height: 200,
      child: CircularProgressIndicator(
        value: progress,
        strokeWidth: 10,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        backgroundColor: Colors.grey[300],
        semanticsLabel: 'Booking progress',
      ),
    );
  }
}
