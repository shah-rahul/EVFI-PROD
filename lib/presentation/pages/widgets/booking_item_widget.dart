// ignore_for_file: prefer_final_fields, file_names, use_key_in_widget_constructors, sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
import '../models/charger_bookings.dart';

import 'package:evfi/presentation/resources/values_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/color_manager.dart';

// ignore: must_be_immutable
class BookingWidget extends StatelessWidget {
  Booking bookingRequest;
  bool _currentSelected;
  BookingWidget(this.bookingRequest, this._currentSelected);

  Widget statusButton() {
    LendingStatus status;
    if (bookingRequest.status == 0) {
      status = LendingStatus.accepted;
    } else {
      status = LendingStatus.declined;
    }
    final Color buttonColor, textColor;
    if (bookingRequest.status == 0) {
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
            status == LendingStatus.accepted
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
                bookingRequest.customerName,
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
                    bookingRequest.amount.toString(),
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
          Text(bookingRequest.stationName,
              style: const TextStyle(fontSize: AppSize.s12)),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              const Icon(Icons.access_time),
              Padding(
                  padding: const EdgeInsets.all(AppPadding.p12 - 8),
                  child: Text(bookingRequest.timeStamp)),
            ],
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
                  Text(bookingRequest.customerMobileNumber,
                      style: const TextStyle(fontSize: AppSize.s12)),
                ],
              ),
              _currentSelected == true
                  ? Row(
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
                  : statusButton()
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
