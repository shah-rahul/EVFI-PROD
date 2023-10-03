// ignore_for_file: non_constant_identifier_names, file_names, prefer_const_constructors, sized_box_for_whitespace
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'package:evfi/presentation/resources/assets_manager.dart';
import 'package:evfi/presentation/resources/font_manager.dart';
import 'package:evfi/presentation/resources/styles_manager.dart';
import 'package:evfi/presentation/pages/screens/2Bookings/list_chargers.dart';
import '../../models/charger_bookings.dart';
import '../../../resources/strings_manager.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/values_manager.dart';
import '../../widgets/booking_item_widget.dart';

// List<Booking> BookingList = [
//   Booking(
//       customerName: "Arshdeep Singh",
//       stationName: "Aomg Charging Station Hub",
//       customerMobileNumber: "+918989898989",
//       timeStamp: DateTime.now().toString(),
//       amount: 120,
//       status: 1,
//       ratings: 4.0),
//   Booking(
//       customerName: "Priyanshu Maikhuri",
//       stationName: "Aomg Charging Station Hub",
//       customerMobileNumber: "+913131313131",
//       timeStamp: DateTime.now().toString(),
//       amount: 120,
//       status: 1,
//       ratings: 4.0)
// ];

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({Key? key}) : super(key: key);
  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  bool _currentSelected = true;
  bool _isProvider = false;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  QuerySnapshot<Map<String, dynamic>>? _userCollection;
  final currentUid = FirebaseAuth.instance.currentUser?.uid;
  late String stationName;

  @override
  void initState() {
    super.initState();
    initializeProvider();
    // print(
    //     'Value of Provide is: $_isProvider ******************************************************');
  }

  void initializeProvider() async {
    _userCollection = await FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: userId)
        .get();
    // print('222222222222222222222');
    if (_userCollection!.docs.isNotEmpty) {
      var doc = _userCollection!.docs[0];
      _isProvider = doc.data()['isProvider'];
    }
    setState(() {});
    // print('*****************************$_isProvider');
  }

  void _addCharger() async {
    Navigator.of(context).push(PageTransition(
        child: const ListCharger(), type: PageTransitionType.theme));
    if (_isProvider) {
      return;
    }
    await FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: userId)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs[0];
        doc.reference.update({'isProvider': true});
      }
    });
    setState(() {
      _isProvider = true;
    });
    // await _userCollection!.update({'isProvider': _isProvider});
  }

  @override
  Widget build(BuildContext context) {
    return _isProvider
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                AppStrings.BookingTitle,
                textAlign: TextAlign.start,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(PageTransition(
                          child: const ListCharger(),
                          type: PageTransitionType.theme));
                    },
                    icon: const Icon(
                      Icons.add_business_outlined,
                      color: Colors.black,
                    ))
              ],
            ),
            body: Container(
                child:
                    _currentSelected ? PendingScreen(context) : RecentScreen()),
          )
        : Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        ColorManager.grey3.withOpacity(0.68),
                        Colors.black87
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: const [0.3, 0.7])),
              child: Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.24),
                      child: Image.asset(
                        ImageAssets.carCharger,
                        scale: 1.35,
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'List, Rent \nand Earn easily.',
                    style: getBoldStyle(
                        fontSize: FontSize.s35, color: ColorManager.primary),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  ElevatedButton.icon(
                      onPressed: _addCharger,
                      icon:
                          const Icon(Icons.bolt, color: Colors.green, size: 35),
                      style: Theme.of(context).elevatedButtonTheme.style,
                      label: const Text(
                        'List your charger',
                        style: TextStyle(
                            fontSize: FontSize.s14,
                            fontWeight: FontWeight.w600),
                      ))
                ],
              ),
            ));
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>>
      getCustomerDetailsByUserId(String customerId) async {
    print("88");
    final customerDetails = await FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: customerId)
        .get();
    await FirebaseFirestore.instance
        .collection('chargers')
        .where('uId', isEqualTo: userId)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs[0];
        stationName = doc.data()['uid'];
      }
    });
    setState(() {});
    print('$stationName is i*********************');
    print('uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu');
    return customerDetails.docs[0];
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
                  return const CircularProgressIndicator();
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

                return ListView.builder(
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: getCustomerDetailsByUserId(
                            documents[index].data()!['userId']),
                        builder: ((context,
                            AsyncSnapshot<
                                    QueryDocumentSnapshot<Map<String, dynamic>>>
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
                            BookingWidget(
                              bookingItem: Booking(
                                  amount: documents[index]['price'],
                                  timeStamp: documents[index]['timeSlot'],
                                  stationName: stationName,
                                  customerName: snapshots.data!['name'],
                                  customerMobileNumber:
                                      snapshots.data!['phoneNumber'],
                                  status: documents[index]['status'],
                                  date: documents[index]['bookingDate'],
                                  id: documents[index].id,
                                  ratings: 4),
                              currentTab: tab,
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

  Widget PendingScreen(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: height * 0.1,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: width * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.BookingScreenPendingTab,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: AppSize.s20, fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
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
                  Timer(Duration(milliseconds: 100), () {
                    setState(() {
                      _currentSelected = false;
                    });
                  });
                },
                child: Container(
                    width: width * 0.5,
                    child: Text(AppStrings.BookingScreenRecentTab,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: AppSize.s20,
                            fontWeight: FontWeight.w500,
                            color: ColorManager.grey3))),
              )
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        streamBuilder(AppStrings.BookingScreenPendingTab)
      ],
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
                  Timer(Duration(milliseconds: 100), () {
                    setState(() {
                      _currentSelected = true;
                    });
                  });
                },
                child: Container(
                  width: width * 0.5,
                  child: Text(AppStrings.BookingScreenPendingTab,
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
                        Text(
                          AppStrings.BookingScreenRecentTab,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: AppSize.s20,
                              fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
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
        SizedBox(
          height: 5,
        ),
        streamBuilder(AppStrings.BookingScreenRecentTab)
      ],
    );
  }
}
