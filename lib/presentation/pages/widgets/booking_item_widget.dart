// ignore_for_file: prefer_final_fields, file_names, use_key_in_widget_constructors, sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
import '../models/charger_bookings.dart';

import 'package:evfi/presentation/resources/values_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/color_manager.dart';

// ignore: must_be_immutable
class BookingWidget extends StatefulWidget {
  Booking bookingItem;
  final String currentTab;
  BookingWidget({required this.bookingItem, required this.currentTab});

  @override
  State<BookingWidget> createState() => _BookingWidgetState();
}

class _BookingWidgetState extends State<BookingWidget> {
  Widget statusButton() {
    LendingStatus status;
    if (widget.bookingItem.status == 0) {
      status = LendingStatus.accepted;
    } else {
      status = LendingStatus.declined;
    }
    final Color buttonColor, textColor;
    if (widget.bookingItem.status == 0) {
      buttonColor = Colors.white;
      textColor = Colors.black;
    } else {
      buttonColor = ColorManager.grey3;
      textColor = Colors.white;
    }

    return ElevatedButton(
        onPressed: () {},
        child: Text(
          status == LendingStatus.accepted
              ? AppStrings.AcceptedStatus
              : AppStrings.DeclinedStatus,
          style: TextStyle(color: textColor),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          elevation: 3,
        ));
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
                widget.bookingItem.customerName,
                style: const TextStyle(
                    fontSize: AppSize.s20, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Icon(
                    Icons.currency_rupee,
                    size: AppSize.s18,
                  ),
                  Text(
                    widget.bookingItem.amount.toString(),
                    style: const TextStyle(
                        fontSize: AppSize.s20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(widget.bookingItem.stationName,
              style: const TextStyle(fontSize: AppSize.s12)),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12 - 8),
            child: Row(
              children: [
                const Icon(Icons.access_time),
                Text(widget.bookingItem.timeStamp, style: TextStyle(fontSize: 12)),
                Spacer(),
                Text(widget.bookingItem.date),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.call,
                    size: AppSize.s18,
                  ),
                  Text(widget.bookingItem.customerMobileNumber,
                      style: const TextStyle(fontSize: AppSize.s12)),
                ],
              ),Row(
                      children: [
                        SizedBox(
                          width: 84,
                          height: 20,
                          child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                AppStrings.AcceptButton,
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 3,
                              )),
                        ),
                        SizedBox(
                          width: AppSize.s12,
                        ),
                        SizedBox(
                          width: 84,
                          height: 20,
                          child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                AppStrings.DeclineButton,
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.grey3,
                                elevation: 3,
                              )),
                        ),
                      ],
                    )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
        ]),
      ),
    );
  }
}
