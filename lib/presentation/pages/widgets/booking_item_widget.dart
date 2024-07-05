// ignore_for_file: prefer_final_fields, file_names, use_key_in_widget_constructors, sort_child_properties_last, prefer_const_constructors
import 'package:evfi/presentation/resources/utils.dart';
import 'package:flutter/material.dart';
import '../models/charger_bookings.dart';
import '../../resources/strings_manager.dart';
import '../../resources/color_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingWidget extends StatefulWidget {
  Booking bookingItem;
  final String currentTab;
  BookingWidget({required this.bookingItem, required this.currentTab});

  @override
  State<BookingWidget> createState() => _BookingWidgetState();
}

class _BookingWidgetState extends State<BookingWidget> {
  Color? buttonColor, textColor;
  String statusText = 'Status';

  void statusButton(int status) {
    switch (status) {
      case -2: //canceled
        {
          buttonColor = ColorManager.statusCancelled;
          textColor = ColorManager.appBlack;
          statusText = 'Cancelled';
        }
        break;
      case -1: //declined
        {
          buttonColor = ColorManager.statusDeclined;
          // textColor = Colors.white;
          textColor = ColorManager.appBlack;
          statusText = 'Declined';
        }
        break;
      case 0: //charging
        {}
        break;
      case 1: //requested
        {
          buttonColor = ColorManager.statusRequested;
          textColor = ColorManager.appBlack;
          statusText = 'Requested';
        }
        break;
      case 2:
        {
          buttonColor = ColorManager.statusAccepted;
          textColor = ColorManager.appBlack;
          statusText = 'Accepted';
        }
        break;
      case 3:
        {
          buttonColor = ColorManager.primary;
          textColor = ColorManager.appBlack;
          statusText = 'Completed';
        }
        break;
    }
  }

  void initState() {
    super.initState();
  }

  Future<void> _launchDialer(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    try {
      await launch(url);
    } catch (e) {
      print('Error launching dialer: $e');
    }
  }

  Widget build(BuildContext context) {
    statusButton(widget.bookingItem.status);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.9,
      height: height * 0.143,
      decoration: BoxDecoration(
        // color: Colors.white,
        color: buttonColor,

        borderRadius: BorderRadius.circular(width * 0.08),
        boxShadow: [
          BoxShadow(
            offset: Offset(-8, 6),
            blurRadius: width * 0.015,
            color: Color.fromRGBO(222, 222, 222, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(width * 0.015),
        child: Column(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.08, vertical: width * 0.003),
                      child: Text(
                        widget.bookingItem.stationName,
                        style: TextStyle(
                          color: textColor,
                          fontSize: width * 0.035,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.08, vertical: width * 0.003),
                      child: Text(
                        widget.bookingItem.customerName,
                        style: TextStyle(
                          color: textColor,
                          fontSize: width * 0.030,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.08, vertical: width * 0.003),
                      child: Text(
                        'Time slot- ${convertTime(widget.bookingItem.timeStamp)}',
                        style: TextStyle(
                          color: textColor,
                          fontSize: width * 0.03,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.08, vertical: width * 0.003),
                      child: Text(
                        '+' + widget.bookingItem.customerMobileNumber,
                        style: TextStyle(
                          color: textColor,
                          fontSize: width * 0.03,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.08, vertical: width * 0.001),
                      child: Text(
                        '₹ ${widget.bookingItem.amount}',
                        style: TextStyle(
                          color: textColor,
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.bookingItem.status != -1 &&
                  widget.bookingItem.status != -2)
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.08, vertical: width * 0.01),
                  child: InkWell(
                    onTap: () async {
                      await _launchDialer(
                          widget.bookingItem.customerMobileNumber);
                    },
                    child: Icon(
                      Icons.phone,
                      color: Colors.black,
                      size: width * 0.04,
                    ),
                  ),
                ),
              if (widget.bookingItem.status == -1 ||
                  widget.bookingItem.status == -2)
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.03, vertical: width * 0.045),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: textColor,
                      fontSize: width * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (widget.bookingItem.status == 1)
                Padding(
                  padding: EdgeInsets.all(width * 0.01),
                  child: Container(
                    //margin: EdgeInsets.symmetric(horizontal: height * 0.01),
                    width: width * 0.28,
                    height: height * 0.03,
                    child: ElevatedButton(
                      onPressed: () {
                        changeBookingStatus(2, widget.bookingItem.id);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                      ),
                      child: const Text(AppStrings.AcceptButton,
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
              if (widget.bookingItem.status == 1)
                Padding(
                  padding: EdgeInsets.all(width * 0.01),
                  child: Container(
                    width: width * 0.28,
                    height: height * 0.03,
                    child: ElevatedButton(
                      onPressed: () {
                        changeBookingStatus(-1, widget.bookingItem.id);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      child: const Text(AppStrings.DeclineButton,
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
            ],
          ),
        ]),
        // SizedBox(height: 100,),
      ),
    );
  }
}