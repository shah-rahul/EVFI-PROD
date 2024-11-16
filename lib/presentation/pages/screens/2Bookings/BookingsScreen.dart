// ignore_for_file: non_constant_identifier_names, file_names, prefer_const_constructors, sized_box_for_whitespace
import 'dart:async';

import 'package:evfi/presentation/pages/screens/2Bookings/list_chargers_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/account.dart';
import 'package:evfi/presentation/resources/routes_manager.dart';
import 'package:evfi/presentation/resources/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../resources/font_manager.dart';
import '../../../storage/UserData.dart';
import '../../models/charger_bookings.dart';
import '../../../resources/strings_manager.dart';
import '../../../resources/color_manager.dart';
import '../../widgets/booking_item_widget.dart';
import 'package:shimmer/shimmer.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({Key? key}) : super(key: key);
  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  bool _currentSelected = true;
  bool? _isProvider = false;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  QuerySnapshot<Map<String, dynamic>>? _userCollection;
  final currentUid = FirebaseAuth.instance.currentUser?.uid;
  String stationName = '';

  @override
  void initState() {
    super.initState();
    checkIfProvider();
  }

  Future<void> checkIfProvider() async {
    final prefs = await SharedPreferences.getInstance();
    // debugPrint(
    //     '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${prefs.getBool('isProvider')}');
    if (prefs.getBool('isProvider') == true) {
      setState(() {
        print(
            'Hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
        _isProvider = true;
      });
    } else {
      _userCollection = await FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: userId)
          .get();
      if (_userCollection!.docs.isNotEmpty) {
        var provider = _userCollection!.docs[0].data()['level3'];
        setState(() {
          prefs.setBool('isProvider', provider);
          _isProvider = provider!;
          // debugPrint(
          //     '#######################################################$_isProvider');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isProvider != true) {
      checkIfProvider();
    }
    if (_isProvider == true) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.BookingTitle,
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.listChargerFormRoute);
                },
                icon: const Icon(
                  Icons.add_business_outlined,
                  color: Colors.black,
                ))
          ],
        ),
        body: Container(
            child: _currentSelected ? PendingScreen(context) : RecentScreen()),
      );
    } else {
      return ListChargersPage();
    }
  }

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
              stream: (tab == AppStrings.BookingScreenPendingTab)
                  ? FirebaseFirestore.instance
                  .collection('booking')
                  .where('providerId', isEqualTo: currentUid)
                  .where('status', whereIn: [0, 1, 2]).snapshots()
                  : FirebaseFirestore.instance
                  .collection('booking')
                  .where('providerId', isEqualTo: currentUid)
                  .where('status', whereIn: [-1, -2, 3]).snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Column(
                      children: List.generate(
                        5,
                            (index) => shimmerPlaceholder(),
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No Bookings yet..'),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                List<DocumentSnapshot<Map<String, dynamic>>> documents =
                    snapshot.data!.docs;
                if (documents.isEmpty) {
                  return Center(
                    child: Text('No Bookings yet...'),
                  );
                }

                return ListView.builder(
                  itemBuilder: (context, index) {
                    List<String> station = [stationName];
                    return FutureBuilder(
                        future: getCustomerDetailsByUserId(
                            documents[index].data()!['uId'],
                            documents[index].data()!['chargerId'],
                            station),
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
                          print(
                              '\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$${station.last}');
                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.01),
                                height: screenHeight * 0.2,
                                child: BookingWidget(
                                  bookingItem: Booking(
                                      amount: documents[index]['price'],
                                      timeStamp: documents[index]['timeSlot'],
                                      stationName: station.last,
                                      customerName:
                                      snapshots.data!['firstName'],
                                      customerMobileNumber:
                                      snapshots.data!['phoneNumber'],
                                      status: documents[index]['status'],
                                      date: documents[index]['bookingDate'],
                                      id: documents[index]['bookingId'],
                                      ratings: 4),
                                  currentTab: tab,
                                ),
                              ),
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

  Widget PendingScreen(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          height: screenHeight * 0.08,
          color: ColorManager.white,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: screenWidth * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.BookingScreenPendingTab,
                        textAlign: TextAlign.center,
                        style: TextStyle(
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
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Timer(Duration(milliseconds: 100), () {
                    setState(() {
                      _currentSelected = false;
                    });
                  });
                },
                child: Container(
                    width: screenWidth * 0.5,
                    child: Text(AppStrings.BookingScreenRecentTab,
                        textAlign: TextAlign.center,
                        style: TextStyle(
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
        streamBuilder(AppStrings.BookingScreenPendingTab)
      ],
    );
  }

  Widget RecentScreen() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          height: screenHeight * 0.08,
          color: ColorManager.white,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Timer(Duration(milliseconds: 100), () {
                    setState(() {
                      _currentSelected = true;
                    });
                  });
                },
                child: Container(
                  width: screenWidth * 0.5,
                  child: Text(AppStrings.BookingScreenPendingTab,
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
                        AppStrings.BookingScreenRecentTab,
                        textAlign: TextAlign.center,
                        style: TextStyle(
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
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          color: ColorManager.white,
          height: screenHeight * 0.05,
        ),
        streamBuilder(AppStrings.BookingScreenRecentTab)
      ],
    );
  }

  Widget shimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
}