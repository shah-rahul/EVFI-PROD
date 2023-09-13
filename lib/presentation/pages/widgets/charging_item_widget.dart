// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, file_names, sort_child_properties_last

import 'dart:math';

import 'package:flutter/material.dart';
import '../models/vehicle_chargings.dart';
import '../../resources/color_manager.dart';
import '../../resources/strings_manager.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:evfi/presentation/resources/values_manager.dart';

class MyChargingWidget extends StatefulWidget {
  Charging chargingItem;
  MyChargingWidget({
    required this.chargingItem,
  });

  @override
  State<MyChargingWidget> createState() => _MyChargingWidgetState();
}

class _MyChargingWidgetState extends State<MyChargingWidget> {
  Widget statusButton(LendingStatus status) {
    // if (status == BookingStatus.Requested) {
    //   bookstatus = BookingStatus.Requested as String;
    // }
    final Color buttonColor, textColor;
    if (status == LendingStatus.requested) {
      buttonColor = Colors.green[500]!;
      textColor = Colors.white;
    } else {
      buttonColor = ColorManager.grey3;
      textColor = Colors.white;
    }

    return SizedBox(
      width: 90,
      height: 30,
      child: ElevatedButton(
          onPressed: () {},
          child: Text(
            status == LendingStatus.requested
                ? AppStrings.RequestedStatus
                : AppStrings.AcceptedStatus,
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
                widget.chargingItem.stationName,
                style: const TextStyle(
                    fontSize: AppSize.s18, fontWeight: FontWeight.bold),
              ),
              statusButton(widget.chargingItem.status),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(widget.chargingItem.stationAddress,
              style: const TextStyle(fontSize: AppSize.s12)),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              const Icon(Icons.access_time),
              Padding(
                  padding: const EdgeInsets.all(AppPadding.p12 - 8),
                  child: Text(widget.chargingItem.slotChosen)),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              RatingBarIndicator(
                rating: Random().nextDouble() * 5,
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 20.0,
                direction: Axis.horizontal,
              ),
              const Spacer(),
              ElevatedButton.icon(
                  onPressed: widget.chargingItem.status == LendingStatus.requested? () {} : null,
                  icon: const Icon(Icons.close, color: Colors.white, size: 20,),
                  label: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.error,
                    elevation: 3,
                  )),
            ],
          ),
          // const SizedBox(
          //   height: 5,
          // ),
        ]),
      ),
    );
  }
}
