// ignore_for_file: unused_field, prefer_final_fields, file_names, sized_box_for_whitespace, non_constant_identifier_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  final currentUid = FirebaseAuth.instance.currentUser?.uid;
  bool _fetchingBookings = false;

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

  Widget streamBuilder(String tab) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.75,
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12 - 4),
      child: SingleChildScrollView(
        child: Container(
            height: height * 0.85,
            child: StreamBuilder(
              stream: (tab == AppStrings.ChargingScreenCurrentTab)
                  ? FirebaseFirestore.instance
                      .collection('booking')
                      .where('userId', isEqualTo: currentUid)
                      .where('status', whereIn: [0, 1, 2]).snapshots()
                  : FirebaseFirestore.instance
                      .collection('booking')
                      .where('userId', isEqualTo: currentUid)
                      .where('status', whereIn: [-1, -2, 3]).snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
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
                    child: Text('No Charging yet'),
                  );

                return ListView.builder(
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: getChargerDetailsByChargerId(
                            documents[index].data()!['chargerId']),
                        builder: ((context,
                            AsyncSnapshot<
                                    DocumentSnapshot<Map<String, dynamic>>>
                                snapshots) {
                          if (snapshots.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
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
                          return Column(children: [
                            MyChargingWidget(
                                chargingItem: Charging(
                                    amount: documents[index]['price'],
                                    position: const LatLng(0,
                                        0), //later to show path till charger we'll use charger coordinates
                                    slotChosen: documents[index]['timeSlot'],
                                    stationAddress: snapshots.data!['info']
                                        ['address'],
                                    stationName: snapshots.data!['info']
                                        ['stationName'],
                                    status: documents[index]['status'],
                                    type: 1,
                                    ratings: 1),
                                currentTab: tab,
                                bookingId: documents[index].id),
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
                          // color: ColorManager.primary,
                          color: Color(0xFFFCFCFD),
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

        Container(
          width: widthInLogicalPixels, // Adjust as needed
          height: heightInLogicalPixels, // Adjust as needed
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                offset: Offset(-8, 6),
                blurRadius: 50,
                color: Color.fromRGBO(0, 0, 0, 0.25),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Rahul ka Charger',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60),
                    child: Text(
                      '₹ 600',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Time slot- 23:00 3:00',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  '73085789349854',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: widthInLogicalPixels1,
                    height: heightInLogicalPixels1,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle the first button click
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                      ),
                      child: const Text('Accept',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  Container(
                    width: widthInLogicalPixels1,
                    height: heightInLogicalPixels1,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle the second button click
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      child: const Text('Decline',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(
          height: 10,
        ),
        Container(
          width: widthInLogicalPixels, // Adjust as needed
          height: heightInLogicalPixels, // Adjust as needed
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                offset: Offset(-8, 6),
                blurRadius: 50,
                color: Color.fromRGBO(0, 0, 0, 0.25),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Rahul ka Charger',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60),
                    child: Text(
                      '₹ 600',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Time slot- 23:00 3:00',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  '73085789349854',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: widthInLogicalPixels1,
                    height: heightInLogicalPixels1,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle the first button click
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                      ),
                      child: const Text('Accept',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  Container(
                    width: widthInLogicalPixels1,
                    height: heightInLogicalPixels1,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle the second button click
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      child: const Text('Decline',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(
          height: 10,
        ),
        Container(
          width: widthInLogicalPixels, // Adjust as needed
          height: heightInLogicalPixels, // Adjust as needed
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                offset: Offset(-8, 6),
                blurRadius: 50,
                color: Color.fromRGBO(0, 0, 0, 0.25),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Rahul ka Charger',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60),
                    child: Text(
                      '₹ 600',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Time slot- 23:00 3:00',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  '73085789349854',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: widthInLogicalPixels1,
                    height: heightInLogicalPixels1,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle the first button click
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                      ),
                      child: const Text('Accept',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  Container(
                    width: widthInLogicalPixels1,
                    height: heightInLogicalPixels1,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle the second button click
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      child: const Text('Decline',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // streamBuilder(AppStrings.ChargingScreenCurrentTab)
      ],
    );
  }

  Widget RecentScreen() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    double widthInLogicalPixels = 990 / MediaQuery.of(context).devicePixelRatio;
    double heightInLogicalPixels =
        340 / MediaQuery.of(context).devicePixelRatio;
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
        const SizedBox(height: 10),
        Container(
          width: widthInLogicalPixels, // Adjust as needed
          height: heightInLogicalPixels, // Adjust as neede
          decoration: BoxDecoration(
            color: Color(0xFFF6D4D5),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                offset: Offset(-8, 6),
                blurRadius: 50,
                color: Color.fromRGBO(0, 0, 0, 0.25),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Rahul ka Charger',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Time slot- 23:00 3:00',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  '73085789349854',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  '₹ 600',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 10,
        ),

        Container(
          width: widthInLogicalPixels, // Adjust as needed
          height: heightInLogicalPixels, // Adjust as neede
          decoration: BoxDecoration(
            color: Color(0xFFD0F4D5),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                offset: Offset(-8, 6),
                blurRadius: 50,
                color: Color.fromRGBO(0, 0, 0, 0.25),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Rahul ka Charger',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Time slot- 23:00 3:00',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  '73085789349854',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  '₹ 600',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 10,
        ),

        Container(
          width: widthInLogicalPixels, // Adjust as needed
          height: heightInLogicalPixels, // Adjust as neede
          decoration: BoxDecoration(
            color: Color(0xFFD0F4D5),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                offset: Offset(-8, 6),
                blurRadius: 50,
                color: Color.fromRGBO(0, 0, 0, 0.25),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Rahul ka Charger',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Time slot- 23:00 3:00',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  '73085789349854',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  '₹ 600',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: widthInLogicalPixels, // Adjust as needed
          height: heightInLogicalPixels, // Adjust as neede
          decoration: BoxDecoration(
            color: Color(0xFFD0F4D5),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                offset: Offset(-8, 6),
                blurRadius: 50,
                color: Color.fromRGBO(0, 0, 0, 0.25),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Rahul ka Charger',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Time slot- 23:00 3:00',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  '73085789349854',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  '₹ 600',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        // streamBuilder(AppStrings.ChargingScreenRecentTab)
      ],
    );
  }
}
