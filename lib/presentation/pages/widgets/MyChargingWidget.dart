import 'package:EVFI/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';
import '../models/MyCharging.dart';
import 'package:intl/intl.dart';
import '../../resources/color_manager.dart';
import '../../resources/strings_manager.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MyChargingWidget extends StatelessWidget {
  MyCharging myCharging;
  MyChargingWidget(this.myCharging);

  Widget statusButton() {
    Status status;
    if (myCharging.status == 0) {
      status = Status.waiting;
    } else if (myCharging.status == 1) {
      status = Status.accepted;
    } else {
      status = Status.rejected;
    }
    final Color buttonColor, textColor;
    if (myCharging.status == 0) {
      buttonColor = Colors.white;
      textColor = Colors.black;
    } else {
      buttonColor = ColorManager.grey3;
      textColor = Colors.white;
    }

    return SizedBox(
      width: 84,
      height: 20,
      child: ElevatedButton(
          onPressed: () {},
          child: Text(
            status == Status.waiting
                ? AppStrings.WaitingStatus
                : status == Status.accepted
                    ? AppStrings.AcceptedStatus
                    : AppStrings.DeclinedStatus,
            style: TextStyle(color: textColor),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            elevation: 3,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    String dateTime = DateFormat.jm().format(myCharging.datetime).toString();
    return Card(
      shadowColor: ColorManager.CardshadowBottomRight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(AppMargin.m12 - 4),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                myCharging.StationName,
                style: const TextStyle(
                    fontSize: AppSize.s20, fontWeight: FontWeight.w600),
              ),
              statusButton(),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(myCharging.StationAddress,
              style: const TextStyle(fontSize: AppSize.s12)),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              const Icon(Icons.access_time),
              Padding(
                  padding: const EdgeInsets.all(AppPadding.p12 - 8),
                  child: Text(dateTime)),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          RatingBarIndicator(
            rating: myCharging.ratings,
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 20.0,
            direction: Axis.horizontal,
          ),
          const SizedBox(
            height: 5,
          ),
        ]),
      ),
    );
  }
}
