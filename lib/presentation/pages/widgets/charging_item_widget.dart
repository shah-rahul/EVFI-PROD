// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, file_names, sort_child_properties_last

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evfi/presentation/resources/utils.dart';
import 'package:flutter/material.dart';
import '../../resources/font_manager.dart';
import '../models/vehicle_chargings.dart';
import '../../resources/color_manager.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:evfi/presentation/resources/values_manager.dart';

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
    // String textContent = determineStatusText(status);

    // if (widget.tab == AppStrings.ChargingScreenCurrentTab &&
    //     (status == LendingStatus.declined || status == LendingStatus.completed))
    //   return Container();
    // if (widget.tab == AppStrings.ChargingScreenRecentTab &&
    //     (status == LendingStatus.accepted ||
    //         status == LendingStatus.requested ||
    //         status == LendingStatus.charging)) return Container();

    // return ElevatedButton(
    //     onPressed: () {},
    //     child: Text(
    //       statusText,
    //       // style: TextStyle(color: textColor),
    //     ),
    //     style: ElevatedButton.styleFrom(
    //       backgroundColor: buttonColor,
    //       foregroundColor: textColor,
    //       elevation: 3,
    //     ));
  }

  @override
  void initState() {
    //getStatusColor();
    super.initState();
  }
  // void getStatusColor() {
  //   if (widget.chargingItem.status == 2)
  //     // statusColor =Color(0xFFF6D4D5);
  //     statusColor = Colors.red;
  //   else if (widget.chargingItem.status == -1) statusColor = Colors.purpleAccent;
  //   ;
  // }

  Widget build(BuildContext context) {
    // getStatusColor();
    statusButton(widget.chargingItem.status);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.9,
      height: height * 0.0,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(width * 0.08),
        boxShadow: [
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
                    padding: EdgeInsets.symmetric(horizontal: width * 0.08, vertical: width * 0.01),
                    child: Text(
                      '+' + widget.chargingItem.phoneNumber,
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
                child: GestureDetector(
                  onTap: () async {
                    CollectionReference users =
                        FirebaseFirestore.instance.collection('booking');
                    DocumentReference docRef =
                        users.doc(widget.chargingItem.id);
                    await docRef.update({
                      'status': -2,
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                    ),
                    child: Column(
                      children:[
                        Container(
                          width: width * 0.06, // Adjust the width of the container
                          height: width * 0.06, // Adjust the height of the container
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white, // Set the background color of the container
                            border: Border.all(
                              color: Colors.black, // Set the border color
                              width: 2.0, // Adjust the border width
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
                        SizedBox(height: height*0.025),
                        Container(
                          width: width * 0.06, // Adjust the width of the container
                          height: width * 0.06, // Adjust the height of the container
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white, // Set the background color of the container
                            border: Border.all(
                              color: Colors.black, // Set the border color
                              width: 2.0, // Adjust the border width
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
                      SizedBox(height: height*0.025),
                      Icon(
                        Icons.assistant_direction,
                        color: Colors.black,
                        size: width * 0.07
                      ),
                    ]
                    ),
                  ),
                ),
              ),
            if (widget.chargingItem.status == 2)
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.07, vertical: width * 0.025),
                  child: Container(
                    decoration: BoxDecoration(
                    ),
                    child: Column(
                        children:[
                          SizedBox(height: height*0.025),
                          Container(
                            width: width * 0.06, // Adjust the width of the container
                            height: width * 0.06, // Adjust the height of the container
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorManager.statusAccepted, // Set the background color of the container
                              border: Border.all(
                                color: Colors.black, // Set the border color
                                width: 2.0, // Adjust the border width
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
                          SizedBox(height: height*0.025),
                          Icon(
                              Icons.assistant_direction,
                              color: Colors.black,
                              size: width * 0.07
                          ),
                        ]
                    ),
                  ),
              ),
            if (widget.chargingItem.status == -1 ||
                widget.chargingItem.status == -2)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: width * 0.045),
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

    // return Container(
    //   width: width * 0.9,
    //   height: height * 0.143,
    //   decoration: BoxDecoration(
    //     color: buttonColor,
    //     borderRadius: BorderRadius.circular(width * 0.08),
    //     boxShadow: [
    //       BoxShadow(
    //         offset: Offset(-8, 6),
    //         blurRadius: 15,
    //         color: Color.fromRGBO(222, 222, 222, 1),
    //       ),
    //     ],
    //   ),
    //   child: Stack(
    //     children: [
    //       Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Row(
    //             children: [
    //               Padding(
    //                 padding: EdgeInsets.symmetric(
    //                     horizontal: width * 0.08, vertical: width * 0.01),
    //                 child: Text(
    //                   widget.chargingItem.stationName,
    //                   style: TextStyle(
    //                     color: textColor,
    //                     fontSize: width * 0.04,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //               ),
    //               // Padding(
    //               //   padding: EdgeInsets.symmetric(horizontal: 60),
    //               //   child: Text(
    //               //     '₹ ${widget.chargingItem.amount.toString()}',
    //               //     style: TextStyle(
    //               //       color: Colors.black,
    //               //       fontSize: 18,
    //               //       fontWeight: FontWeight.bold,
    //               //     ),
    //               //   ),
    //               // ),
    //             ],
    //           ),
    //           // SizedBox(height: 5),
    //           Padding(
    //             padding: EdgeInsets.symmetric(
    //                 horizontal: width * 0.08, vertical: width * 0.01),
    //             child: Text(
    //               'Time slot- ${widget.chargingItem.slotChosen}',
    //               style: TextStyle(
    //                 color: textColor,
    //                 fontSize: width * 0.04,
    //               ),
    //             ),
    //           ),
    //           // SizedBox(height: 5),
    //           Padding(
    //             padding: EdgeInsets.symmetric(
    //                 horizontal: width * 0.08, vertical: width * 0.01),
    //             child: Text(
    //               widget.chargingItem.phoneNumber,
    //               style: TextStyle(
    //                 color: textColor,
    //                 fontSize: width * 0.04,
    //               ),
    //             ),
    //           ),
    //           // SizedBox(height: 0),
    //           Padding(
    //             padding: EdgeInsets.symmetric(
    //                 horizontal: width * 0.08, vertical: width * 0.01),
    //             child: Text(
    //               '₹ ${widget.chargingItem.amount}',
    //               style: TextStyle(
    //                 color: textColor,
    //                 fontSize: width * 0.06,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           ),
    //
    //           // Row(
    //           //   children: [
    //           //     Padding(
    //           //       padding: EdgeInsets.all(40),
    //           //     ),
    //           //     if (widget.chargingItem.status == 1)
    //           //       GestureDetector(
    //           //         onTap: () async {
    //           //           CollectionReference users =
    //           //               FirebaseFirestore.instance.collection('booking');
    //           //           DocumentReference docRef =
    //           //               users.doc(widget.chargingItem.id);
    //           //           await docRef.update({
    //           //             'status': -1,
    //           //           });
    //           //         },
    //           //         child: ClipOval(
    //           //           child: Icon(
    //           //             Icons.close,
    //           //             color: Colors.red,
    //           //             size: 60,
    //           //           ),
    //           //         ),
    //           //       ),
    //           //   ],
    //           // ),
    //           // if (widget.chargingItem.status == 2 ||
    //           //     widget.chargingItem.status == -1)
    //
    //           //change the color accordingly
    //         ],
    //       ),
    //       if (widget.chargingItem.status == 1)
    //       Positioned(
    //         right: width * 0.02,
    //         top: width * 0.13,
    //         child: GestureDetector(
    //           onTap: () async {
    //             CollectionReference users =
    //             FirebaseFirestore.instance.collection('booking');
    //             DocumentReference docRef = users.doc(widget.chargingItem.id);
    //             await docRef.update({
    //               'status': -1,
    //             });
    //           },
    //           child: Container(
    //             decoration: BoxDecoration(
    //               boxShadow: [
    //                 BoxShadow(
    //                   color: Colors.grey.withOpacity(0.1),
    //                 ),
    //               ],
    //             ),
    //             child: Icon(
    //               Icons.close,
    //               color: Colors.red,
    //               size: width * 0.08,
    //             ),
    //           ),
    //         ),
    //       ),
    //       if (widget.chargingItem.status == -1 || widget.chargingItem.status == -2 )
    //         Text(
    //             statusText,
    //             style: TextStyle(
    //               color: textColor,
    //               fontSize: width * 0.035,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //     ],
    //   ),
    // );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Card(
  //     shadowColor: ColorManager.CardshadowBottomRight,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     elevation: 4,
  //     color: Colors.white,
  //     child: Padding(
  //       padding: const EdgeInsets.all(AppMargin.m12 - 4),
  //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               widget.chargingItem.stationName,
  //               style: const TextStyle(
  //                   fontSize: AppSize.s20, fontWeight: FontWeight.bold),
  //             ),
  //             statusButton(widget.chargingItem.status),
  //           ],
  //         ),
  //         Text(widget.chargingItem.stationAddress,
  //             style: const TextStyle(fontSize: AppSize.s14)),
  //         const SizedBox(
  //           height: 5,
  //         ),
  //         Row(
  //           children: [
  //             const Icon(Icons.access_time),
  //             Text(
  //               widget.chargingItem.slotChosen,
  //               style: const TextStyle(fontSize: 12),
  //             ),
  //             const Spacer(),
  //             Text(widget.chargingItem.date),
  //           ],
  //         ),
  //         const SizedBox(
  //           height: 8,
  //         ),
  //         Row(
  //           children: [
  //             RatingBarIndicator(
  //               rating: Random().nextDouble() * 5,
  //               itemBuilder: (context, index) => const Icon(
  //                 Icons.star,
  //                 color: Colors.amber,
  //               ),
  //               itemCount: 5,
  //               itemSize: 23.0,
  //               direction: Axis.horizontal,
  //             ),
  //             const Spacer(),
  //             if (widget.chargingItem.status == 1)
  //               ElevatedButton.icon(
  //                   onPressed: () async {
  //                     CollectionReference users =
  //                         FirebaseFirestore.instance.collection('booking');
  //                     DocumentReference docRef =
  //                         users.doc(widget.chargingItem.id);
  //                     await docRef.update({
  //                       'status': -1,
  //                     });
  //                   },
  //                   icon: const Icon(
  //                     Icons.close,
  //                     color: Colors.white,
  //                     size: 20,
  //                   ),
  //                   label: const Text(
  //                     '\tCancel',
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: ColorManager.error,
  //                     elevation: 3,
  //                   )),
  //           ],
  //         ),
  //       ]),
  //     ),
  //   );
  // }
}
