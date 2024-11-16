// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, file_names, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evfi/presentation/resources/utils.dart';
import 'package:flutter/material.dart';
import '../../resources/font_manager.dart';
import '../models/vehicle_chargings.dart';
import '../../resources/color_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class MyChargingWidget extends StatefulWidget {
  Charging chargingItem;
  String currentTab;
  MyChargingWidget({required this.chargingItem, required this.currentTab});

  @override
  State<MyChargingWidget> createState() => _MyChargingWidgetState();
}

class _MyChargingWidgetState extends State<MyChargingWidget> {
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

  @override
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

  @override
  Widget build(BuildContext context) {
    statusButton(widget.chargingItem.status);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.9,
      height: height * 0.0,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(width * 0.08),
        boxShadow: const [
          BoxShadow(
            offset: Offset(4, 4),
            blurRadius: 15,
            color: Color.fromRGBO(222, 222, 222, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(width * 0.02),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.08, vertical: width * 0.01),
                    child: Text(
                      widget.chargingItem.stationName,
                      style: TextStyle(
                        fontFamily: FontConstants.appTitleFontFamily,
                        color: textColor,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.08, vertical: width * 0.01),
                    child: Text(
                      'Slot- ${convertTime(widget.chargingItem.slotChosen)}',
                      style: TextStyle(
                        fontFamily: FontConstants.appTitleFontFamily,
                        color: textColor,
                        fontSize: width * 0.04,
                      ),
                    ),
                  ),
                  if (widget.chargingItem.status != -1)
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.08, vertical: width * 0.01),
                      child: Text(
                        '+${widget.chargingItem.phoneNumber}',
                        style: TextStyle(
                          fontFamily: FontConstants.appTitleFontFamily,
                          color: textColor,
                          fontSize: width * 0.04,
                        ),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.08, vertical: width * 0.01),
                    child: Text(
                      '₹ ${widget.chargingItem.amount}',
                      style: TextStyle(
                        color: textColor,
                        fontFamily: FontConstants.appTitleFontFamily,
                        fontSize: width * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.chargingItem.status == 1)
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.07, vertical: width * 0.025),
                child: Container(
                  decoration: const BoxDecoration(),
                  child: Column(
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                CollectionReference users = FirebaseFirestore.instance.collection('booking');
                                DocumentReference docRef = users.doc(widget.chargingItem.id);
                                await docRef.update({
                                  'status': -2,
                                });
                              },
                              child: Container(
                                width: width * 0.06,
                                height: width * 0.06,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.black,
                                    size: width * 0.04,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            InkWell(
                              onTap: () async {
                                await _launchDialer(
                                    widget.chargingItem.phoneNumber);
                              },
                              child: Container(
                                width: width * 0.06,
                                height: width * 0.06,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.phone,
                                    color: Colors.black,
                                    size: width * 0.04,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            // Icon(
                            //   Icons.assistant_direction,
                            //   color: Colors.black,
                            //   size: width * 0.07,
                            // ),
                          ]),
                    ],
                  ),
                ),
              ),
            if (widget.chargingItem.status == 2)
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.07, vertical: width * 0.025),
                child: Container(
                  decoration: const BoxDecoration(),
                  child: Column(children: [
                    SizedBox(height: height * 0.025),
                    InkWell(
                      onTap: () async {
                        await _launchDialer(widget.chargingItem.phoneNumber);
                      },
                      child: Container(
                        width: width * 0.06,
                        height: width * 0.06,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorManager.statusAccepted,
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.phone,
                            color: Colors.black,
                            size: width * 0.04,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.025),
                    // Icon(Icons.assistant_direction,
                    //     color: Colors.black, size: width * 0.07),
                  ]),
                ),
              ),
            if (widget.chargingItem.status == -1 ||
                widget.chargingItem.status == -2)
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03, vertical: width * 0.045),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: textColor,
                    fontFamily: FontConstants.appTitleFontFamily,
                    fontSize: width * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}