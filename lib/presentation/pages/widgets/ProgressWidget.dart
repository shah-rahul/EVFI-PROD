import 'package:evfi/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';
import '../../resources/color_manager.dart';
import 'dart:async';

class ProgressWidget extends StatefulWidget {
  final DateTime startTime;
  final DateTime endTime;

  const ProgressWidget(this.startTime, this.endTime, {super.key});
  @override
  State<ProgressWidget> createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    print('-----');
    // Start a timer to update UI every second
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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

    Duration remainingTime = widget.endTime.difference(now);
    print(remainingTime);
    print('done got time');
    return Container(
        child: CircularTimer(
      duration: remainingTime,
    ));
  }
}

class CircularTimer extends StatelessWidget {
  final Duration duration;

  const CircularTimer({Key? key, required this.duration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress =
        1 - (duration.inSeconds / (60 * 60)); // Calculate progress (in hours)

    return SingleChildScrollView(
        child: Container(
            height: 200,
            padding: const EdgeInsets.all(AppMargin.m20),
            child: Card(
                shadowColor: ColorManager.CardshadowBottomRight,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.all(
                  Radius.circular(40),
                )),
                elevation: 4,
                color: Colors.white,
                child: Padding(
                    padding: const EdgeInsets.all(AppMargin.m14),
                    child: Center(
                      // Wrap CircularProgressIndicator with AspectRatio to maintain square shape
                      child: AspectRatio(
                        aspectRatio: 1.0, // 1.0 for a perfect square
                        child: Stack(children: [
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 10,
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(Colors.blue),
                              backgroundColor: Colors.grey[300],
                              semanticsLabel: 'Booking progress',
                            ),
                          ),
                          Text(
                            'Time Left ${1 - (duration.inSeconds / 60).round()}', // Your text here
                            style: const TextStyle(
                              fontSize: AppSize.s16,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ]),
                      ),
                    )))));
  }
}
