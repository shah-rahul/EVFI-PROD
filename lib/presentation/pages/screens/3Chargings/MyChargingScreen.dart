// ignore_for_file: unused_field, prefer_final_fields, file_names, sized_box_for_whitespace, non_constant_identifier_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evfi/presentation/resources/font_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// import 'package:evfi/presentation/pages/streams/charging_stream.dart';
import 'package:evfi/presentation/pages/models/vehicle_chargings.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../resources/strings_manager.dart';
import '../../../resources/color_manager.dart';
import 'package:evfi/presentation/resources/values_manager.dart';
import '../../widgets/charging_item_widget.dart';

class MyChargingScreen extends StatefulWidget {
  const MyChargingScreen({Key? key}) : super(key: key);
  @override
  State<MyChargingScreen> createState() => _MyChargingScreenState();
}

class _MyChargingScreenState extends State<MyChargingScreen> {
  bool _currentSelected = true;
  // List<Charging> _streamData = [];
  // late Stream bookingReference;

  // void function() {
  //   bookingReference = FirebaseFirestore.instance
  //       .collection('booking')
  //       .snapshots()
  //       .map((QuerySnapshot querySnapshot) {
  //
  //     final currentUserUID = FirebaseAuth.instance.currentUser?.uid;

  //     for (QueryDocumentSnapshot bookingSnapshot in querySnapshot.docs) {
  //       // Assuming your Charging class has a constructor that takes a Map<String, dynamic>
  //       Charging bookingUid =
  //           (bookingSnapshot.data() as Map<String, dynamic>)['uid'];

  //       if ("LUE2zApEe9RA58RybIQswHvR2h03" == bookingUid) {
  //
  //       }
  //
  //     }
  //
  //   });

  //
  // }
  final currentUid = FirebaseAuth.instance.currentUser?.uid;
  bool _fetchingBookings = false;
  Widget shimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: ColorManager.grey5!,
      highlightColor: ColorManager.white!,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        height: 100 *
            MediaQuery.textScaleFactorOf(
                context), // Adjust the height as needed
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.MyChargingTitle,
            textAlign: TextAlign.start,
            style: TextStyle(
                fontFamily: FontConstants.appTitleFontFamily,
                fontSize: FontSize.s20,
                color: ColorManager.appBlack),
          ),
          elevation: 0,
          backgroundColor: ColorManager.white,
        ),
        body: Container(
          child: _currentSelected ? currentScreen(context) : RecentScreen(),
        ));
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getChargerDetailsByChargerId(
      String chargerId, String providerId, List<String> phoneNumber) async {
    final chargerDetails = await FirebaseFirestore.instance
        .collection('chargers')
        .doc(chargerId)
        .get();

    await getPhoneNumber(providerId, phoneNumber);
    print(phoneNumber);
    return chargerDetails;
  }

  CollectionReference users = FirebaseFirestore.instance.collection('user');

  Future<void> getPhoneNumber(String uid, List<String> phoneNumber) async {
    final doc = await users.doc(uid).get();

    if (doc.exists && doc.data() != null) {
      phoneNumber.add((doc.data() as Map<String, dynamic>)['phoneNumber']);
    } else {}
  }

  // DocumentReference docRef =
//your bookings
  Widget streamBuilder(String tab) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.75,
      //padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12 - 4),
      child: SingleChildScrollView(
        child: Container(
            height: screenHeight * 0.85,
            width: screenWidth,
            color: ColorManager.white,
            child: StreamBuilder(
              stream: (tab == AppStrings.ChargingScreenCurrentTab)
                  ? FirebaseFirestore.instance
                      .collection('booking')
                      .where('uId', isEqualTo: currentUid)
                      .where('status', whereIn: [0, 1, 2]).snapshots()
                  : FirebaseFirestore.instance
                      .collection('booking')
                      .where('uId', isEqualTo: currentUid)
                      .where('status', whereIn: [-1, -2, 3]).snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: List.generate(
                      5,
                      (index) => shimmerPlaceholder(),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No Chargings yet..'),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                // final listOfChargings = snapshot.data!;
                List<DocumentSnapshot<Map<String, dynamic>>> documents =
                    snapshot.data!.docs;
                // print(documents[0]);
                if (documents.length == 0)
                  return Center(
                    child: Text('No Chargings yet..'),
                  );
                List<String> phoneNumber = [];
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: getChargerDetailsByChargerId(
                            documents[index].data()!['chargerId'],
                            documents[index].data()!['providerId'],
                            phoneNumber),
                        builder: ((context,
                            AsyncSnapshot<
                                    DocumentSnapshot<Map<String, dynamic>>>
                                snapshots) {
                          if (snapshots.connectionState ==
                              ConnectionState.waiting) {
                            return shimmerPlaceholder();
                          }
                          if (!snapshots.hasData) {
                            return const Center(
                              child: Text('No Bookings yet..'),
                            );
                          }
                          if (snapshots.hasError) {
                            return const Center(
                                child: Text('Something went wrong'));
                          }

                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.01),
                                height: screenHeight * 0.2,
                                child: MyChargingWidget(
                                  chargingItem: Charging(
                                      amount:
                                          documents[index]['price'],
                                      phoneNumber: phoneNumber.length > 0
                                          ? phoneNumber[phoneNumber.length - 1]
                                          : "",
                                      position: const LatLng(0,
                                          0), //later to show path till charger we'll use charger coordinates
                                      slotChosen: documents[index]['timeSlot'],
                                      stationAddress: snapshots.data!['info']
                                          ['address'],
                                      stationName: snapshots.data!['info']
                                          ['stationName'],
                                      status: documents[index]['status'],
                                      date: documents[index]['bookingDate'],
                                      id: documents[index]['bookingId'],
                                      type: 1,
                                      ratings: 1),
                                  currentTab: tab,
                                ),
                              )
                              // SizedBox(
                              //   height: screenHeight * 0.01,
                              // ),
                            ],
                          );
                        }));
                  },
                  itemCount: documents.length,
                );
              },
            )),
      ),
    );
  }

  // Widget streamBuilder(String tab) {
  //   final height = MediaQuery.of(context).size.height;
  //   return Container(
  //     height: height * 0.75,
  //     padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12 - 4),
  //     child: SingleChildScrollView(
  //       child: Container(
  //           height: height * 0.85,
  //           child: StreamBuilder(
  //             stream: (tab == AppStrings.ChargingScreenCurrentTab)
  //                 ? FirebaseFirestore.instance
  //                     .collection('booking')
  //                     .where('userId', isEqualTo: currentUid)
  //                     .where('status', whereIn: [0, 1, 2]).snapshots()
  //                 : FirebaseFirestore.instance
  //                     .collection('booking')
  //                     .where('userId', isEqualTo: currentUid)
  //                     .where('status', whereIn: [-1, -2, 3]).snapshots(),
  //             builder: (context,
  //                 AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
  //               if (snapshot.connectionState == ConnectionState.waiting) {
  //                 return const CircularProgressIndicator();
  //               }
  //               if (!snapshot.hasData) {
  //                 return const Center(
  //                   child: Text('No Chargings yet..'),
  //                 );
  //               }
  //               if (snapshot.hasError) {
  //                 return const Center(child: Text('Something went wrong'));
  //               }

  //               // final listOfChargings = snapshot.data!;
  //               List<DocumentSnapshot<Map<String, dynamic>>> documents =
  //                   snapshot.data!.docs;
  //               // print(documents[0]);

  //               return ListView.builder(
  //                 itemBuilder: (context, index) {
  //                   return FutureBuilder(
  //                       future: getChargerDetailsByChargerId(
  //                           documents[index].data()!['chargerId']),
  //                       builder: ((context,
  //                           AsyncSnapshot<
  //                                   DocumentSnapshot<Map<String, dynamic>>>
  //                               snapshots) {
  //                         if (snapshots.connectionState ==
  //                             ConnectionState.waiting) {
  //                           return const CircularProgressIndicator();
  //                         }
  //                         if (!snapshots.hasData) {
  //                           return const Center(
  //                             child: Text('No Bookings yet..'),
  //                           );
  //                         }
  //                         if (snapshots.hasError) {
  //                           return const Center(
  //                               child: Text('Something went wrong'));
  //                         }
  //                         return Column(children: [
  //                           MyChargingWidget(
  //                               chargingItem: Charging(
  //                                   amount: documents[index]['price'],
  //                                   position: const LatLng(0,
  //                                       0), //later to show path till charger we'll use charger coordinates
  //                                   slotChosen: documents[index]['timeSlot'],
  //                                   stationAddress: snapshots.data!['info']
  //                                       ['address'],
  //                                   stationName: snapshots.data!['info']
  //                                       ['stationName'],
  //                                   status: documents[index]['status'],
  //                                   type: 1,
  //                                   ratings: 1),
  //                               currentTab: tab,
  //                               bookingId: documents[index].id),
  //                           const SizedBox(
  //                             height: 5,
  //                           )
  //                         ]);
  //                       }));
  //                 },
  //                 itemCount: documents.length,
  //               );
  //             },
  //           )),
  //     ),
  //   );
  // }

  // Future<DocumentSnapshot<Map<String, dynamic>>> getChargerDetailsByChargerId(
  //     String chargerId) async {
  //   print("88");
  //   final chargerDetails = await FirebaseFirestore.instance
  //       .collection('chargers')
  //       .doc(chargerId)
  //       .get();
  //   return chargerDetails;
  // }

  // final currentUid = FirebaseAuth.instance.currentUser?.uid;
  Widget currentScreen(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    double widthInLogicalPixels = 990 / MediaQuery.of(context).devicePixelRatio;
    double heightInLogicalPixels =
        340 / MediaQuery.of(context).devicePixelRatio;
    double widthInLogicalPixels1 =
        394.835 / MediaQuery.of(context).devicePixelRatio;
    double heightInLogicalPixels1 =
        81.83 / MediaQuery.of(context).devicePixelRatio;

    return Column(
      children: [
        Container(
          height: screenHeight * 0.08,
          color: ColorManager.white,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  // function();
                  // print('Called Function');
                },
                child: Container(
                  width: screenWidth * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.ChargingScreenCurrentTab,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: FontConstants.appTitleFontFamily,
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.012, vertical: screenHeight * 0.005),
                        child: Container(
                          height: screenHeight * 0.005,
                          width: screenWidth * 0.2,
                          color: ColorManager.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Timer(const Duration(milliseconds: 100), () {
                    setState(() {
                      _currentSelected = false;
                    });
                  });
                },
                child: Container(
                    width: screenWidth * 0.5,
                    child: Text(AppStrings.ChargingScreenRecentTab,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: FontConstants.appTitleFontFamily,
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w500,
                            color: ColorManager.grey3))),
              )
            ],
          ),
        ),
        Container(
          color: ColorManager.white,
          height: screenHeight * 0.05,
        ),
        streamBuilder(AppStrings.ChargingScreenCurrentTab),
      ],
    );
  }

  Widget RecentScreen() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    double widthInLogicalPixels = 990 / MediaQuery.of(context).devicePixelRatio;
    double heightInLogicalPixels =
        340 / MediaQuery.of(context).devicePixelRatio;
    return Column(
      children: [
        Container(
          height: screenHeight * 0.08,
          color: ColorManager.white,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Timer(const Duration(milliseconds: 100), () {
                    setState(() {
                      _currentSelected = true;
                    });
                  });
                },
                child: Container(
                  width: screenWidth * 0.5,
                  child: Text(AppStrings.ChargingScreenCurrentTab,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: FontConstants.appTitleFontFamily,
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w500,
                          color: ColorManager.grey3)),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                    width: screenWidth * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.ChargingScreenRecentTab,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: FontConstants.appTitleFontFamily,
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.012, vertical: screenHeight * 0.005),
                          child: Container(
                            height: screenHeight * 0.005,
                            width: screenWidth * 0.2,
                            color: ColorManager.primary,
                          ),
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
        Container(
          color: ColorManager.white,
          height: screenHeight * 0.05,
        ),
        streamBuilder(AppStrings.ChargingScreenRecentTab),
      ],
    );
  }
}
