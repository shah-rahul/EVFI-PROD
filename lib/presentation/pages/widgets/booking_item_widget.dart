// ignore_for_file: prefer_final_fields, file_names, use_key_in_widget_constructors, sort_child_properties_last, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
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
  // Widget statusButton() {
  //   LendingStatus status;
  //   if (widget.bookingItem.status == 0) {
  //     status = LendingStatus.accepted;
  //   } else {
  //     status = LendingStatus.declined;
  //   }
  //   final Color buttonColor, textColor;
  //   if (widget.bookingItem.status == 0) {
  //     buttonColor = Colors.white;
  //     textColor = Colors.black;
  //   } else {
  //     buttonColor = ColorManager.grey3;
  //     textColor = Colors.white;
  //   }
  //   return SizedBox(
  //     width: 84,
  //     height: 20,
  //     child: ElevatedButton(
  //         onPressed: () {},
  //         child: Text(
  //           status == LendingStatus.accepted
  //               ? AppStrings.AcceptedStatus
  //               : AppStrings.DeclinedStatus,
  //           style: TextStyle(color: textColor),
  //         ),
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: buttonColor,
  //           elevation: 3,
  //         )),
  //   );
  // }
  Color? buttonColor, textColor ;
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
    // final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    // return SizedBox(
    //   width: width * 0.25,
    //   height: height * 0.04,
    //   child: ElevatedButton(
    //       onPressed: () {},
    //       child: Text(
    //         statusText,
    //         // style: TextStyle(color: textColor),
    //       ),
    //       style: ElevatedButton.styleFrom(
    //         backgroundColor: buttonColor,
    //         foregroundColor: textColor,
    //         elevation: 3,
    //       )),
    // );
  }

  // Color statusColor = Colors.white;
  void initState() {
    // getStatusColor();
    super.initState();
  }

  // void getStatusColor() {
  //   if (widget.bookingItem.status == 2)
  //     // statusColor =;
  //     // statusColor = Colors.white;
  //     statusColor = Color(0xFFD0F4D5);
  //   else if (widget.bookingItem.status == 1)
  //     statusColor = Colors.white;
  //   else
  //     statusColor = Color(0xFFF6D4D5);
  //   // statusColor = Colors.white;
  //   ;
  // }

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

        borderRadius: BorderRadius.circular(width*0.08),
        boxShadow: [
          BoxShadow(
            offset: Offset(-8, 6),
            blurRadius: width * 0.015,
            color: Color.fromRGBO(222, 222, 222, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(width*0.02),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width*0.08, vertical: width*0.008),
                    child: Text(
                      widget.bookingItem.customerName,
                      style: TextStyle(
                        color: textColor,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                //SizedBox(height: height * 0.01),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal:width*0.08, vertical: width*0.01),
                    child: Text(
                      'Time slot- ${widget.bookingItem.timeStamp}',
                      style: TextStyle(
                        color: textColor,
                        fontSize: width * 0.04,
                      // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                //SizedBox(height: height * 0.01),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal:width*0.08, vertical: width*0.01), // Add vertical padding
                    child: Text(
                      '+'+widget.bookingItem.customerMobileNumber,
                      style: TextStyle(
                        color: textColor,
                        fontSize: width * 0.04,
                    // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                //SizedBox(height: height * 0.01),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal:width*0.08, vertical: width*0.01), // Add vertical padding
                    child: Text(
                      '₹ ${widget.bookingItem.amount}',
                      style: TextStyle(
                        color: textColor,
                        fontSize: width * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                // if (widget.bookingItem.status == 2 ||
                //     widget.bookingItem.status == -1)
                //    getStatusColor(widget.bookingItem.status),
                // statusButton(widget.bookingItem.status),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                        if (widget.bookingItem.status == 1 )
                        Padding(
                          padding: EdgeInsets.all(width * 0.02),
                          child: Container(
                          //margin: EdgeInsets.symmetric(horizontal: height * 0.01),
                            width: width * 0.3,
                            height: height * 0.03,
                            child: ElevatedButton(
                              onPressed: () async {
                                CollectionReference users = FirebaseFirestore
                                .instance
                                .collection('booking');
                                DocumentReference docRef =
                                users.doc(widget.bookingItem.id);
                                await docRef.update({
                                  'status': 2,
                                });
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
                        padding: EdgeInsets.all(width * 0.02),
                        child: Container(
                        // width: widthInLogicalPixels1,
                        // height: heightInLogicalPixels1,
                          width: width * 0.3,
                          height: height * 0.03,

                          child: ElevatedButton(
                            onPressed: () async {
                              CollectionReference users = FirebaseFirestore
                                .instance
                                .collection('booking');
                              DocumentReference docRef =
                                users.doc(widget.bookingItem.id);
                              await docRef.update({
                                'status': -1,
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor:MaterialStateProperty.all<Color>(Colors.red),
                            ),
                            child: const Text(AppStrings.DeclineButton,
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
                ),
              if (widget.bookingItem.status == -1 || widget.bookingItem.status == -2 )
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: width * 0.045),
              child:Text(
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
      // SizedBox(height: 100,),
    ),
    );
  }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shadowColor: ColorManager.CardshadowBottomRight,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 4,
//       color: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(AppMargin.m12 - 4),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 widget.bookingItem.customerName,
//                 style: const TextStyle(
//                     fontSize: AppSize.s20, fontWeight: FontWeight.w600),
//               ),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.currency_rupee,
//                     size: AppSize.s18,
//                   ),
//                   Text(
//                     widget.bookingItem.amount.toString(),
//                     style: const TextStyle(
//                         fontSize: AppSize.s20, fontWeight: FontWeight.w600),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: 8,
//           ),
//           Text(widget.bookingItem.stationName,
//               style: const TextStyle(fontSize: AppSize.s12)),
//           const SizedBox(
//             height: 5,
//           ),
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12 - 8),
// //             child: Row(
// //               children: [
// //                 const Icon(Icons.access_time),
// //                 Text(widget.bookingItem.timeStamp, style: TextStyle(fontSize: 12)),
// //                 Spacer(),
// //                 Text(widget.bookingItem.date),
// //               ],
// //             ),
// //           ),
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//             Row(
//               children: [
//                 const Icon(Icons.access_time),
//                 Padding(
//                     padding: const EdgeInsets.all(AppPadding.p12 - 8),
//                     child: Text(widget.bookingItem.timeStamp)),
//               ],
//             ),
//             if (widget.bookingItem.status == 2 ||
//                 widget.bookingItem.status == -1)
//               statusButton(widget.bookingItem.status)
//           ]),
//           const SizedBox(
//             height: 5,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Icon(
//                     Icons.call,
//                     size: AppSize.s18,
//                   ),
//                   Text(widget.bookingItem.customerMobileNumber,
//                       style: const TextStyle(fontSize: AppSize.s12)),
//                 ],
//               ),
//               Row(
//                 children: [
//                   if (widget.bookingItem.status != 2 &&
//                       widget.bookingItem.status != -1)
//                     SizedBox(
//                       width: 84,
//                       height: 20,
//                       child: ElevatedButton(
//                           onPressed: () async {
//                             CollectionReference users = FirebaseFirestore
//                                 .instance
//                                 .collection('booking');
//                             DocumentReference docRef =
//                                 users.doc(widget.bookingItem.id);
//                             await docRef.update({
//                               'status': 2,
//                             });
//                           },
//                           child: Text(
//                             AppStrings.AcceptButton,
//                             style: TextStyle(color: Colors.black),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white,
//                             elevation: 3,
//                           )),
//                     ),
//                   SizedBox(
//                     width: AppSize.s12,
//                   ),
//                   if (widget.bookingItem.status != -1)
//                     SizedBox(
//                       width: 84,
//                       height: 20,
//                       child: ElevatedButton(
//                           onPressed: () async {
//                             CollectionReference users = FirebaseFirestore
//                                 .instance
//                                 .collection('booking');
//                             DocumentReference docRef =
//                                 users.doc(widget.bookingItem.id);
//                             await docRef.update({
//                               'status': -1,
//                             });
//                           },
//                           child: Text(
//                             AppStrings.DeclineButton,
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: ColorManager.grey3,
//                             elevation: 3,
//                           )),
//                     ),
//                 ],
//               )
//             ],
//           ),
//           const SizedBox(
//             height: 5,
//           ),
//         ]),
//       ),
//     );
//   }
}
