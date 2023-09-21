// ignore_for_file: unused_field, prefer_final_fields, file_names, sized_box_for_whitespace, non_constant_identifier_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:evfi/presentation/pages/streams/charging_stream.dart';
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
  //     // print(querySnapshot);
  //     print('000000000000');
  //     final currentUserUID = FirebaseAuth.instance.currentUser?.uid;

  //     for (QueryDocumentSnapshot bookingSnapshot in querySnapshot.docs) {
  //       // Assuming your Charging class has a constructor that takes a Map<String, dynamic>
  //       Charging bookingUid =
  //           (bookingSnapshot.data() as Map<String, dynamic>)['uid'];

  //       if ("LUE2zApEe9RA58RybIQswHvR2h03" == bookingUid) {
  //         print(bookingSnapshot.data());
  //         print("------------");
  //       }
  //       print('11111111');
  //     }
  //     print('2222222');
  //   });

  //   print('33333333333');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            AppStrings.MyChargingTitle,
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          child: _currentSelected ? currentScreen(context) : RecentScreen(),
        ));
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getChargerDetailsByChargerId(
      String chargerId) async {
    print("88");
    final chargerDetails = await FirebaseFirestore.instance
        .collection('chargers')
        .doc(chargerId)
        .get();
    return chargerDetails;
  }

  final currentUid = FirebaseAuth.instance.currentUser?.uid;
  Widget currentScreen(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          height: height * 0.1,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  // function();
                  // print('Called Function');
                },
                child: Container(
                  width: width * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        AppStrings.ChargingScreenCurrentTab,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: AppSize.s20, fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p12 - 2,
                            vertical: AppMargin.m12 - 8),
                        child: Container(
                          height: 1.8,
                          width: width * 0.32,
                          color: ColorManager.primary,
                        ),
                      )
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
                    width: width * 0.5,
                    child: Text(AppStrings.ChargingScreenRecentTab,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: AppSize.s20,
                            fontWeight: FontWeight.w500,
                            color: ColorManager.grey3))),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        streamBuilder(AppStrings.ChargingScreenCurrentTab)
      ],
    );
  }

  Widget streamBuilder(String tab) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.75,
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12 - 4),
      child: SingleChildScrollView(
        child: Container(
            height: height * 0.85,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('booking')
                  .where('userId', isEqualTo: currentUid)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
                  // return const CircularProgressIndicator();
                  return const Center(
                    child: Text('No Bookings yet..'),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                // final listOfChargings = snapshot.data!;
                List<DocumentSnapshot<Map<String, dynamic>>> documents =
                    snapshot.data!.docs;

                print(currentUid);

                print("--------------");

                return ListView.builder(
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: getChargerDetailsByChargerId(
                            documents[index].data()?['chargerId']),
                        builder: ((context,
                            AsyncSnapshot<
                                    DocumentSnapshot<Map<String, dynamic>>>
                                snapshots) {
                          return Column(children: [
                            MyChargingWidget(
                              chargingItem: Charging(
                                  amount: 12,
                                  position: LatLng(0, 0),
                                  slotChosen: "0",
                                  stationAddress: snapshots.data!['info']
                                      ['address'],
                                  stationName: snapshots.data!['info']
                                      ['stationName'],
                                  status: LendingStatus.requested,
                                  type: 1,
                                  ratings: 0),
                              tab: tab,
                            ),
                            const SizedBox(
                              height: 5,
                            )
                          ]);
                        }));
                  },
                  itemCount: documents.length,
                );
              },
            )),
      ),
    );
  }

  Widget RecentScreen() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: height * 0.1,
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
                  width: width * 0.5,
                  child: Text(AppStrings.ChargingScreenCurrentTab,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: AppSize.s20,
                          fontWeight: FontWeight.w500,
                          color: ColorManager.grey3)),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                    width: width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          AppStrings.ChargingScreenRecentTab,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: AppSize.s20,
                              fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppPadding.p12 - 2,
                              vertical: AppMargin.m12 - 8),
                          child: Container(
                            height: 1.8,
                            width: width * 0.32,
                            color: ColorManager.primary,
                          ),
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        streamBuilder(AppStrings.ChargingScreenRecentTab)
      ],
    );
  }
}
